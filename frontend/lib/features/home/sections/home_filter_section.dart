import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/catergory_selection_provider.dart';
import 'package:frontend/Providers/status_selection_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/home/widgets/category_filter_tab.dart';
import 'package:frontend/features/home/widgets/status_filter_chip.dart';

class HomeFilterSection extends ConsumerWidget {
  const HomeFilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatus = ref.watch(statusSelectionProvider);
    final currentCategory = ref.watch(categorySelectionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Filter Bar
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: context.appColors.shadow.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Row(
            children: statuses(context).entries.map((entry) {
              final isSelected = currentStatus == entry.key.toLowerCase();
              return Expanded(
                child: StatusFilterChip(
                  title: entry.value,
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(statusSelectionProvider.notifier).state =
                        entry.key.toLowerCase();
                  },
                ),
              );
            }).toList(),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
        14.verticalSpace,
        // Category Filter Horizontal List
        SizedBox(
          height: 36.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: categories.map((cat) {
              final isSelected =
                  currentCategory.toLowerCase() == cat.toLowerCase();
              return CategoryFilterTab(
                title: cat,
                isSelected: isSelected,
                onTap: () {
                  ref.read(categorySelectionProvider.notifier).state =
                      cat.toLowerCase();
                },
              );
            }).toList(),
          ),
        )
            .animate()
            .fadeIn(delay: 150.ms, duration: 400.ms)
            .slideX(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}
