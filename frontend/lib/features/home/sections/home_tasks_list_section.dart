import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Services/task_filter_service.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/tasks/widgets/task_card.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';

class HomeTasksListSection extends ConsumerWidget {
  const HomeTasksListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final useLocalDb = !isOnline || !isLoggedIn;

    if (useLocalDb) {
      final localTasksAsync = ref.watch(fetchlocalDB);
      return localTasksAsync.when(
        data: (tasks) => _buildTaskList(context, ref, tasks),
        loading: () => _buildLoading(context),
        error: (e, _) => Center(
          child: AppText(
            text: 'Error loading tasks: $e',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: context.appColors.error,
            ),
          ),
        ),
      );
    }

    final userEmail = ref.watch(prefProvider).maybeWhen(
          data: (p) => p.getString('userEmail') ?? '',
          orElse: () => '',
        );

    if (userEmail.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 40.r,
              color: context.appColors.onSurfaceVariant,
            ),
            12.verticalSpace,
            AppText(
              text: AppLocalizations.of(context)!.loginStatment,
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: context.appColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final remoteTasksAsync = ref.watch(tasksListProvider(userEmail));
    return remoteTasksAsync.when(
      data: (tasks) => _buildTaskList(context, ref, tasks),
      loading: () => _buildLoading(context),
      error: (e, _) => Center(
        child: AppText(
          text: 'Error loading tasks: $e',
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: context.appColors.error,
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: context.appColors.primary,
        strokeWidth: 2.5.r,
      ),
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    WidgetRef ref,
    List<TaskModel> allTasks,
  ) {
    final filtered = filterTasks(allTasks, ref);

    if (filtered.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 36.h),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 44.r,
              color: context.appColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            10.verticalSpace,
            AppText(
              text: 'No tasks found',
              style: AppTextStyles.titleMedium(context).copyWith(
                color: context.appColors.onSurfaceVariant,
              ),
            ),
            4.verticalSpace,
            AppText(
              text: 'Tap + above to create a task',
              style: AppTextStyles.bodySmall(context),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => 10.verticalSpace,
      itemBuilder: (context, index) => TaskCard(task: filtered[index])
          .animate()
          .fadeIn(
            delay: (index * 45).clamp(0, 300).ms,
            duration: 350.ms,
          )
          .slideY(
            begin: 0.08,
            end: 0,
            duration: 350.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}

