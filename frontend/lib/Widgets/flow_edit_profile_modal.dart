import 'package:flutter/material.dart';
import 'package:frontend/features/settings/widgets/edit_profile_dialog.dart';

export 'package:frontend/features/settings/widgets/edit_profile_dialog.dart';

class FlowEditProfileModal extends StatelessWidget {
  const FlowEditProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditProfileDialog();
  }
}
