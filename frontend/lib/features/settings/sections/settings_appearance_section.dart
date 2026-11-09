import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/color_scheme_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/settings/widgets/color_scheme_picker.dart';
import 'package:frontend/features/settings/widgets/setting_group_card.dart';
import 'package:frontend/features/settings/widgets/setting_switch_tile.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';

class SettingsAppearanceSection extends ConsumerWidget {
  const SettingsAppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return SettingGroupCard(
      title: AppLocalizations.of(context)!.appearance,
      children: [
        SettingSwitchTile(
          icon: Icons.dark_mode_outlined,
          title: AppLocalizations.of(context)!.darkMode,
          subtitle: isDark
              ? AppLocalizations.of(context)!.enabled
              : AppLocalizations.of(context)!.disabled,
          value: isDark,
          onChanged: (value) async {
            ref.read(isDarkModeProvider.notifier).state = value;
            final prefs = await ref.read(prefProvider.future);
            await prefs.setBool('isDarkMode', value);
          },
        ),
        Divider(color: context.appColors.border, height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: AppLocalizations.of(context)!.colorScheme,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              10.verticalSpace,
              const ColorSchemePicker(),
            ],
          ),
        ),
      ],
    );
  }
}

