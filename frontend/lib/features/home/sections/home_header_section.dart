import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/tasks/sections/task_form_dialog.dart';
import 'package:frontend/widgets/app_text.dart';

final _headerCategoryProvider = StateProvider.autoDispose<String>((ref) => '');
final _headerPriorityProvider = StateProvider.autoDispose<String>((ref) => '');
final _headerDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

class HomeHeaderSection extends ConsumerWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dateStr =
        '${_monthName(now.month)} ${now.day}, ${now.year}';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.appColors.primary,
            context.appColors.primary,
            context.appColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primary.withValues(alpha: 0.3),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 26.r,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40.r, minHeight: 40.r),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => TaskFormDialog(
                        categorySelectionProvider: _headerCategoryProvider,
                        prioritySelectionProvider: _headerPriorityProvider,
                        pickedDateProvider: _headerDateProvider,
                        titleController: TextEditingController(),
                        descriptionController: TextEditingController(),
                      ),
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: context.appColors.primary,
                    iconSize: 22.r,
                    padding: EdgeInsets.all(8.r),
                  ),
                  icon: const Icon(Icons.add_rounded),
                )
                    .animate()
                    .scale(
                      delay: 300.ms,
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),
              ],
            ),
            12.verticalSpace,
            AppText(
              text: dateStr,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            4.verticalSpace,
            AppText(
              text: 'FocusFlow',
              style: AppTextStyles.headlineMedium(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(delay: 250.ms, duration: 500.ms)
                .slideX(begin: -0.05, end: 0, curve: Curves.easeOutCubic)
                .shimmer(
                  delay: 800.ms,
                  duration: 1200.ms,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(
          begin: -0.15,
          end: 0,
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
