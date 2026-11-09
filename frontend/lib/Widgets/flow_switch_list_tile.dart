import 'package:flutter/material.dart';
import 'package:frontend/features/settings/widgets/setting_switch_tile.dart';

export 'package:frontend/features/settings/widgets/setting_switch_tile.dart';

class FlowSwitchListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function(bool) onPressed;
  final bool? value;

  const FlowSwitchListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SettingSwitchTile(
      title: title,
      subtitle: subtitle,
      value: value ?? false,
      onChanged: onPressed,
    );
  }
}
