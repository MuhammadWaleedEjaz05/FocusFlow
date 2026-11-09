import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _style({
    required BuildContext context,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    final langCode =
        Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';

    if (langCode == 'ar') {
      return GoogleFonts.cairo(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height ?? 1.35,
      );
    } else if (langCode == 'ur') {
      return GoogleFonts.notoNastaliqUrdu(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height ?? 1.9,
      );
    }

    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // --- Headlines (Screen titles, hero headers) ---
  static TextStyle headlineLarge(BuildContext context) {
    return _style(
      context: context,
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: context.appColors.onSurface,
      letterSpacing: -0.5,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return _style(
      context: context,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: context.appColors.onSurface,
      letterSpacing: -0.3,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return _style(
      context: context,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: context.appColors.onSurface,
    );
  }

  // --- Titles (Section headers, card titles, dialog headers) ---
  static TextStyle titleLarge(BuildContext context) {
    return _style(
      context: context,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: context.appColors.onSurface,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return _style(
      context: context,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: context.appColors.onSurface,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return _style(
      context: context,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: context.appColors.onSurface,
    );
  }

  // --- Body (Descriptions, inputs, body copy) ---
  static TextStyle bodyLarge(BuildContext context) {
    return _style(
      context: context,
      fontSize: 15.sp,
      fontWeight: FontWeight.normal,
      color: context.appColors.onSurface,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return _style(
      context: context,
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: context.appColors.onSurface,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return _style(
      context: context,
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: context.appColors.onSurfaceVariant,
    );
  }

  // --- Labels (Buttons, badges, chips, captions) ---
  static TextStyle labelLarge(BuildContext context) {
    return _style(
      context: context,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: context.appColors.onPrimary,
      letterSpacing: 0.1,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return _style(
      context: context,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: context.appColors.onSurface,
      letterSpacing: 0.1,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return _style(
      context: context,
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
      color: context.appColors.onSurfaceVariant,
      letterSpacing: 0.2,
    );
  }
}
