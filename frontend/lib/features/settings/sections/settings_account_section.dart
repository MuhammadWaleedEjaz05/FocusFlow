import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/settings/widgets/change_password_dialog.dart';
import 'package:frontend/features/settings/widgets/confirm_delete_dialog.dart';
import 'package:frontend/features/settings/widgets/edit_profile_dialog.dart';
import 'package:frontend/features/settings/widgets/setting_action_tile.dart';
import 'package:frontend/features/settings/widgets/setting_group_card.dart';
import 'package:frontend/l10n/app_localizations.dart';

class SettingsAccountSection extends ConsumerWidget {
  const SettingsAccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final isLoggedIn = ref.watch(prefProvider).maybeWhen(
          data: (prefs) => prefs.getBool('isLoggedIn') ?? false,
          orElse: () => false,
        );

    if (!isOnline || !isLoggedIn) {
      return const SizedBox.shrink();
    }

    return SettingGroupCard(
      title: AppLocalizations.of(context)!.account,
      children: [
        SettingActionTile(
          icon: Icons.person_outline_rounded,
          title: AppLocalizations.of(context)!.profile,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const EditProfileDialog(),
            );
          },
        ),
        Divider(color: context.appColors.border, height: 16.h),
        SettingActionTile(
          icon: Icons.lock_outline_rounded,
          title: AppLocalizations.of(context)!.changePassword,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const ChangePasswordDialog(),
            );
          },
        ),
        Divider(color: context.appColors.border, height: 16.h),
        SettingActionTile(
          icon: Icons.delete_outline_rounded,
          title: AppLocalizations.of(context)!.deleteAccount,
          isDestructive: true,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const ConfirmDeleteDialog(),
            );
          },
        ),
      ],
    );
  }
}

