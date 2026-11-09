import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/color_scheme_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';

class ColorSchemePicker extends ConsumerWidget {
  const ColorSchemePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(colorSchemeIndexProvider);

    return SizedBox(
      height: 48.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: lightschemes.length,
        separatorBuilder: (_, _) => 12.horizontalSpace,
        itemBuilder: (context, index) {
          final isSelected = currentIndex == index;
          final colors = lightschemes[index].colors;

          return InkWell(
            onTap: () async {
              ref.read(colorSchemeIndexProvider.notifier).state = index;
              final prefs = await ref.read(prefProvider.future);
              await prefs.setInt('colorSchemeIndex', index);
            },
            borderRadius: BorderRadius.circular(14.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64.w,
              height: 44.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isSelected
                      ? context.appColors.onSurface
                      : Colors.transparent,
                  width: 2.2.r,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colors.first.withValues(alpha: 0.35),
                          blurRadius: 8.r,
                          offset: Offset(0, 3.h),
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20.r,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

