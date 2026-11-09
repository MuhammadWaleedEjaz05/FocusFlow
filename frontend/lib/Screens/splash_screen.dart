import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/screen_navigation_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/core/routes/app_page_transitions.dart';
import 'package:frontend/widgets/app_text.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ambientController;
  late final AnimationController _pulseController;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    final screenIndex = ref.read(screenNavigationProvider);
    final targetWidget = screens(context)[screenIndex].screenWidget;

    Navigator.pushReplacement(
      context,
      AppPageRoute.fadeScale(targetWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userProvider, (previous, next) {
      next.when(
        data: (_) {
          Future.delayed(const Duration(milliseconds: 2400), () {
            if (mounted) _navigateToNext();
          });
        },
        error: (_, _) {
          Future.delayed(const Duration(milliseconds: 2800), () {
            if (mounted) _navigateToNext();
          });
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: context.appColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Dynamic Ambient Background Gradients
          _buildAnimatedBackground(),

          // 2. Floating Star / Particle Accents
          _buildFloatingParticles(),

          // 3. Central Brand Composition
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedLogo(),
                28.verticalSpace,
                _buildAnimatedTitle(),
                10.verticalSpace,
                _buildAnimatedSubtitle(),
              ],
            ),
          ),

          // 4. Bottom Flowing Progress Indicator
          Positioned(
            left: 48.w,
            right: 48.w,
            bottom: 48.h,
            child: _buildBottomProgress(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _ambientController,
      builder: (context, child) {
        final angle = _ambientController.value * 2 * math.pi;
        final dx = math.sin(angle) * 35.w;
        final dy = math.cos(angle) * 35.h;

        return Stack(
          children: [
            // Base Deep Gradient
            Container(
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
              ),
            ),
            // Floating Orb 1 (Top-Left)
            Positioned(
              top: -60.h + dy,
              left: -40.w + dx,
              child: Container(
                width: 260.r,
                height: 260.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.18),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Floating Orb 2 (Bottom-Right)
            Positioned(
              bottom: -40.h - dy,
              right: -50.w - dx,
              child: Container(
                width: 280.r,
                height: 280.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      context.appColors.primaryLight.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return IgnorePointer(
      child: Stack(
        children: [
          _buildParticle(top: 140.h, left: 60.w, size: 6.r, phase: 0.0),
          _buildParticle(top: 220.h, right: 70.w, size: 8.r, phase: 0.3),
          _buildParticle(bottom: 240.h, left: 80.w, size: 5.r, phase: 0.6),
          _buildParticle(bottom: 180.h, right: 90.w, size: 7.r, phase: 0.9),
        ],
      ),
    );
  }

  Widget _buildParticle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double phase,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final wave = math.sin((_pulseController.value + phase) * math.pi);
          final scale = 0.8 + 0.4 * wave;
          final opacity = (0.3 + 0.4 * wave).clamp(0.0, 1.0);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: opacity),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: opacity * 0.8),
                    blurRadius: 6.r,
                    spreadRadius: 1.r,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseScale = 1.0 + (_pulseController.value * 0.08);
        final glowOpacity = 0.2 + (_pulseController.value * 0.2);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outermost Pulsating Aura Ring
            Transform.scale(
              scale: pulseScale * 1.35,
              child: Container(
                width: 110.r,
                height: 110.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: glowOpacity * 0.35),
                ),
              ),
            ),
            // Middle Pulsating Glow Ring
            Transform.scale(
              scale: pulseScale * 1.15,
              child: Container(
                width: 96.r,
                height: 96.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: glowOpacity * 0.6),
                ),
              ),
            ),
            // Central Glassmorphic Brand Container
            Container(
              width: 88.r,
              height: 88.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 2.2.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 48.r,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    )
        // Entrance animation: Elastic pop with 360 rotation settle
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: 900.ms,
          curve: Curves.elasticOut,
        )
        .rotate(
          begin: -0.3,
          end: 0.0,
          duration: 800.ms,
          curve: Curves.easeOutBack,
        )
        .shimmer(
          delay: 1000.ms,
          duration: 1200.ms,
          color: Colors.white.withValues(alpha: 0.6),
        );
  }

  Widget _buildAnimatedTitle() {
    return AppText(
      text: 'FocusFlow',
      style: AppTextStyles.headlineLarge(context).copyWith(
        fontSize: 34.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.8,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 14.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 400.ms, duration: 700.ms)
        .slideY(
          begin: 0.35,
          end: 0.0,
          duration: 700.ms,
          curve: Curves.easeOutCubic,
        )
        .shimmer(
          delay: 1200.ms,
          duration: 1400.ms,
          color: Colors.white.withValues(alpha: 0.7),
        );
  }

  Widget _buildAnimatedSubtitle() {
    return AppText(
      text: 'Stay Focused, Stay Productive',
      style: AppTextStyles.bodyMedium(context).copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.85),
        letterSpacing: 0.4,
      ),
    )
        .animate()
        .fadeIn(delay: 700.ms, duration: 600.ms)
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildBottomProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flowing Shimmer Progress Capsule
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 900.ms, duration: 500.ms)
            .shimmer(
              duration: 1200.ms,
              color: Colors.white.withValues(alpha: 0.8),
            ),
        12.verticalSpace,
        AppText(
          text: 'Preparing your workspace...',
          style: AppTextStyles.labelSmall(context).copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 1100.ms, duration: 500.ms),
      ],
    );
  }
}
