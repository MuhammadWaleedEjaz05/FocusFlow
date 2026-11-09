import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/push_notifications_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/settings/widgets/setting_group_card.dart';
import 'package:frontend/features/settings/widgets/setting_switch_tile.dart';
import 'package:frontend/l10n/app_localizations.dart';

class SettingsNotificationSection extends ConsumerWidget {
  const SettingsNotificationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotificationOn = ref.watch(isNotificationsInitializedProvider);
    final isSoundOn = ref.watch(isSoundOnProvider);

    return SettingGroupCard(
      title: AppLocalizations.of(context)!.notification,
      children: [
        SettingSwitchTile(
          icon: Icons.notifications_none_rounded,
          title: AppLocalizations.of(context)!.pushNotification,
          subtitle:
              AppLocalizations.of(context)!.pushNotificationDescription,
          value: isNotificationOn,
          onChanged: (value) async {
            ref.read(isNotificationsInitializedProvider.notifier).state =
                value;
            final prefs = await ref.read(prefProvider.future);
            await prefs.setBool('isNotificationsInitialized', value);
          },
        ),
        Divider(color: context.appColors.border, height: 16.h),
        SettingSwitchTile(
          icon: Icons.volume_up_outlined,
          title: AppLocalizations.of(context)!.sound,
          subtitle: AppLocalizations.of(context)!.playSound,
          value: isSoundOn,
          onChanged: (value) async {
            ref.read(isSoundOnProvider.notifier).state = value;
            final prefs = await ref.read(prefProvider.future);
            await prefs.setBool('isSoundOn', value);
          },
        ),
      ],
    );
  }
}

