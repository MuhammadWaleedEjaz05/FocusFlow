import 'package:flutter/material.dart';
import 'package:frontend/features/settings/widgets/confirm_delete_dialog.dart';

export 'package:frontend/features/settings/widgets/confirm_delete_dialog.dart';

class FlowConfirmDeleteModal extends StatelessWidget {
  const FlowConfirmDeleteModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConfirmDeleteDialog();
  }
}
