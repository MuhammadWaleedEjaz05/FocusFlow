import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/home/widgets/overview_stat_card.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';

class HomeOverviewSection extends ConsumerWidget {
  const HomeOverviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final useLocalDb = !isOnline || !isLoggedIn;

    if (useLocalDb) {
      final localTasksAsync = ref.watch(fetchlocalDB);
      return localTasksAsync.when(
        data: (tasks) => _buildCard(context, tasks),
        loading: () => _buildLoading(context),
        error: (e, _) => const SizedBox.shrink(),
      );
    }

    final userEmail = ref.watch(prefProvider).maybeWhen(
          data: (p) => p.getString('userEmail') ?? '',
          orElse: () => '',
        );

    if (userEmail.isEmpty) {
      return _buildCard(context, []);
    }

    final remoteTasksAsync = ref.watch(tasksListProvider(userEmail));
    return remoteTasksAsync.when(
      data: (tasks) => _buildCard(context, tasks),
      loading: () => _buildLoading(context),
      error: (e, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.appColors.border),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: context.appColors.primary,
          strokeWidth: 2.5.r,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<TaskModel> tasks) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final active = total - completed;
    final urgent = tasks
        .where((t) => !t.isCompleted && t.priority.toLowerCase() == 'high')
        .length;
    final percentage = total > 0 ? ((completed / total) * 100).round() : 0;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.appColors.border),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: AppLocalizations.of(context)!.overview,
                    style: AppTextStyles.titleLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.verticalSpace,
                  AppText(
                    text: '$completed of $total tasks completed',
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ),
              Container(
                height: 56.r,
                width: 56.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.appColors.primary,
                      context.appColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.appColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Center(
                  child: AppText(
                    text: '$percentage%',
                    style: AppTextStyles.titleMedium(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    delay: 200.ms,
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),
            ],
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OverviewStatCard(
                  title: AppLocalizations.of(context)!.active,
                  icon: Icons.radio_button_unchecked_rounded,
                  count: active,
                  color: context.appColors.primary,
                )
                    .animate()
                    .fadeIn(delay: 250.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              ),
              8.horizontalSpace,
              Expanded(
                child: OverviewStatCard(
                  title: AppLocalizations.of(context)!.completed,
                  icon: Icons.check_circle_outline_rounded,
                  count: completed,
                  color: context.appColors.success,
                )
                    .animate()
                    .fadeIn(delay: 320.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              ),
              8.horizontalSpace,
              Expanded(
                child: OverviewStatCard(
                  title: AppLocalizations.of(context)!.urgent,
                  icon: Icons.error_outline_rounded,
                  count: urgent,
                  color: context.appColors.error,
                )
                    .animate()
                    .fadeIn(delay: 390.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 150.ms, duration: 450.ms)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1.0, 1.0),
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

