import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color primaryLight;
  final Color background;
  final Color surface;
  final Color onPrimary;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color shadow;
  final Color border;
  final Color error;
  final Color success;
  final Color warning;

  const AppColors({
    required this.primary,
    required this.primaryLight,
    required this.background,
    required this.surface,
    required this.onPrimary,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.shadow,
    required this.border,
    required this.error,
    required this.success,
    required this.warning,
  });

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryLight,
    Color? background,
    Color? surface,
    Color? onPrimary,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? shadow,
    Color? border,
    Color? error,
    Color? success,
    Color? warning,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onPrimary: onPrimary ?? this.onPrimary,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      shadow: shadow ?? this.shadow,
      border: border ?? this.border,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t) ?? onSurfaceVariant,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
      border: Color.lerp(border, other.border, t) ?? border,
      error: Color.lerp(error, other.error, t) ?? error,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
    );
  }
}

extension AppColorsBuildContext on BuildContext {
  AppColors get appColors {
    final colors = Theme.of(this).extension<AppColors>();
    if (colors != null) return colors;

    // Fallback based on brightness
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? AppColorsDark.purple : AppColorsLight.purple;
  }
}

class AppColorsLight {
  static AppColors fromPrimary({
    required Color primary,
    required Color primaryLight,
  }) {
    return AppColors(
      primary: primary,
      primaryLight: primaryLight,
      background: Colors.white,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Colors.black,
      onSurfaceVariant: Colors.blueGrey.shade600,
      shadow: Colors.blueGrey.shade100,
      border: Colors.blueGrey.shade200,
      error: Colors.red,
      success: Colors.green,
      warning: Colors.orange,
    );
  }

  static final purple = fromPrimary(
    primary: Colors.deepPurple,
    primaryLight: Colors.purple,
  );
  static final blue = fromPrimary(
    primary: Colors.blue,
    primaryLight: Colors.lightBlue,
  );
  static final green = fromPrimary(
    primary: Colors.green,
    primaryLight: Colors.lightGreen,
  );
  static final orange = fromPrimary(
    primary: Colors.orange,
    primaryLight: Colors.deepOrange,
  );
}

class AppColorsDark {
  static AppColors fromPrimary({
    required Color primary,
    required Color primaryLight,
  }) {
    return AppColors(
      primary: primary,
      primaryLight: primaryLight,
      background: Colors.blueGrey.shade900,
      surface: const Color(0xFF263238),
      onPrimary: Colors.white,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.blueGrey.shade300,
      shadow: Colors.blueGrey.shade700,
      border: Colors.blueGrey.shade700,
      error: Colors.redAccent,
      success: Colors.lightGreen,
      warning: Colors.orangeAccent,
    );
  }

  static final purple = fromPrimary(
    primary: Colors.deepPurple,
    primaryLight: Colors.purple,
  );
  static final blue = fromPrimary(
    primary: Colors.blue,
    primaryLight: Colors.lightBlue,
  );
  static final green = fromPrimary(
    primary: Colors.green,
    primaryLight: Colors.lightGreen,
  );
  static final orange = fromPrimary(
    primary: Colors.orange,
    primaryLight: Colors.deepOrange,
  );
}

