import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/lang_selection_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/settings/widgets/setting_action_tile.dart';
import 'package:frontend/features/settings/widgets/setting_group_card.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';

class SettingsLanguageSection extends ConsumerWidget {
  const SettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLangCode = ref.watch(langSelectionProvider);
    final currentLangName = langSelectionList.entries
        .firstWhere(
          (e) => e.value == currentLangCode,
          orElse: () => const MapEntry('English', 'en'),
        )
        .key;

    return SettingGroupCard(
      title: AppLocalizations.of(context)!.appSettings,
      children: [
        SettingActionTile(
          icon: Icons.language_rounded,
          title: AppLocalizations.of(context)!.language,
          subtitle: currentLangName,
          onTap: () => _showLanguageSheet(context, ref, currentLangCode),
        ),
      ],
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    WidgetRef ref,
    String currentCode,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: context.appColors.border,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                16.verticalSpace,
                AppText(
                  text: AppLocalizations.of(context)!.language,
                  style: AppTextStyles.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                ...langSelectionList.entries.map((entry) {
                  final isSelected = entry.value == currentCode;
                  return InkWell(
                    onTap: () async {
                      ref.read(langSelectionProvider.notifier).state =
                          entry.value;
                      final prefs = await ref.read(prefProvider.future);
                      await prefs.setString('lang', entry.value);

                      if (!bottomSheetContext.mounted) return;
                      Navigator.pop(bottomSheetContext);
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 8.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: entry.key,
                            style: AppTextStyles.bodyLarge(context).copyWith(
                              color: isSelected
                                  ? context.appColors.primary
                                  : context.appColors.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: context.appColors.primary,
                              size: 20.r,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                8.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}

