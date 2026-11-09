import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/widgets/app_text.dart';

class TaskDueDateChip extends StatelessWidget {
  final DateTime dueDate;

  const TaskDueDateChip({
    super.key,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final isPast = due.isBefore(today);

    final dateText = dueDate.toString().split(' ')[0];
    final color = isPast ? context.appColors.error : context.appColors.warning;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.8.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPast ? Icons.warning_amber_rounded : Icons.calendar_today_rounded,
            size: 12.r,
            color: color,
          ),
          4.horizontalSpace,
          AppText(
            text: dateText,
            style: AppTextStyles.labelSmall(context).copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              decoration: isPast ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}

