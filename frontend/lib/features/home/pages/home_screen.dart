import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/lang_selection_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Widgets/flow_drawer.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/home/sections/home_filter_section.dart';
import 'package:frontend/features/home/sections/home_header_section.dart';
import 'package:frontend/features/home/sections/home_overview_section.dart';
import 'package:frontend/features/home/sections/home_tasks_list_section.dart';
import 'package:frontend/features/home/sections/home_weather_section.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UpgradeAlert(
      upgrader: Upgrader(
        minAppVersion: '1.0.0',
        countryCode: ref.watch(langSelectionProvider),
      ),
      child: Scaffold(
        backgroundColor: context.appColors.background,
        drawer: const FlowDrawer(),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            color: context.appColors.primary,
            onRefresh: () async {
              final userEmail = ref.read(prefProvider).maybeWhen(
                    data: (prefs) => prefs.getString('userEmail') ?? '',
                    orElse: () => '',
                  );
              if (userEmail.isNotEmpty) {
                ref.invalidate(tasksListProvider(userEmail));
              }
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                const SliverToBoxAdapter(
                  child: HomeHeaderSection(),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16.r),
                  sliver: SliverList.list(
                    children: [
                      const HomeWeatherSection(),
                      16.verticalSpace,
                      const HomeOverviewSection(),
                      16.verticalSpace,
                      const HomeFilterSection(),
                      16.verticalSpace,
                      const HomeTasksListSection(),
                      24.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

