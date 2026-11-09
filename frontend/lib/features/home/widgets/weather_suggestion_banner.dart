import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/widgets/app_text.dart';

class WeatherSuggestionBanner extends StatelessWidget {
  final String suggestion;

  const WeatherSuggestionBanner({
    super.key,
    required this.suggestion,
  });

  IconData _getWeatherIcon(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('rain')) return Icons.beach_access_rounded;
    if (lower.contains('snow')) return Icons.ac_unit_rounded;
    if (lower.contains('hot')) return Icons.wb_sunny_rounded;
    if (lower.contains('cold')) return Icons.severe_cold_rounded;
    if (lower.contains('hazy') || lower.contains('fog')) {
      return Icons.cloud_queue_rounded;
    }
    if (lower.contains('cloud')) return Icons.cloud_outlined;
    return Icons.wb_sunny_rounded;
  }

  @override
  Widget build(BuildContext context) {
    if (suggestion.isEmpty) return const SizedBox.shrink();

    final icon = _getWeatherIcon(suggestion);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.appColors.primary,
            context.appColors.primaryLight,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primary.withValues(alpha: 0.25),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24.r)
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
          12.horizontalSpace,
          Expanded(
            child: AppText(
              text: suggestion,
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(
          begin: 0.12,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        )
        .shimmer(
          delay: 800.ms,
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.2),
        );
  }
}
