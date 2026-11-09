import 'package:flutter/material.dart';
import 'package:frontend/features/settings/widgets/change_password_dialog.dart';

export 'package:frontend/features/settings/widgets/change_password_dialog.dart';

class FlowChangePasswordModal extends StatelessWidget {
  const FlowChangePasswordModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChangePasswordDialog();
  }
}
