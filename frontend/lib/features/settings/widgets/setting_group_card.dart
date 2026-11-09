import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/widgets/app_text.dart';

class SettingGroupCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingGroupCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title.toUpperCase(),
          style: AppTextStyles.labelSmall(context).copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: context.appColors.onSurfaceVariant,
          ),
        ),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.appColors.border),
            boxShadow: [
              BoxShadow(
                color: context.appColors.shadow.withValues(alpha: 0.08),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 380.ms)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 380.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
