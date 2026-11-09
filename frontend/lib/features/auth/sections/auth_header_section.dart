import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/widgets/app_text.dart';

class AuthHeaderSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AuthHeaderSection({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.appColors.primary,
                context.appColors.primaryLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: context.appColors.primary.withValues(alpha: 0.25),
                blurRadius: 16.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Icon(icon, size: 48.r, color: Colors.white),
        )
            .animate()
            .scale(
              delay: 100.ms,
              duration: 700.ms,
              curve: Curves.elasticOut,
            )
            .slideY(
              begin: -0.15,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
        16.verticalSpace,
        AppText(
          text: title,
          style: AppTextStyles.headlineSmall(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
        6.verticalSpace,
        AppText(
          text: subtitle,
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: context.appColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 400.ms)
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}
