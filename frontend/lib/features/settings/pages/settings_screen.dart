import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Widgets/flow_drawer.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/settings/sections/settings_account_section.dart';
import 'package:frontend/features/settings/sections/settings_appearance_section.dart';
import 'package:frontend/features/settings/sections/settings_language_section.dart';
import 'package:frontend/features/settings/sections/settings_notification_section.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_app_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      drawer: const FlowDrawer(),
      appBar: CustomAppBar(
        leading: Builder(
          builder: (scaffoldContext) => IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: context.appColors.onSurface,
              size: 24.r,
            ),
            onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
          ),
        ),
        title: AppLocalizations.of(context)!.settings,
        showBottomBorder: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              const SettingsAppearanceSection(),
              20.verticalSpace,
              const SettingsNotificationSection(),
              20.verticalSpace,
              const SettingsAccountSection(),
              20.verticalSpace,
              const SettingsLanguageSection(),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

