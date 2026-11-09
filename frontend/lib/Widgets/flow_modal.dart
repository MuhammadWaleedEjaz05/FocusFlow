import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/features/tasks/sections/task_form_dialog.dart';

export 'package:frontend/features/tasks/sections/task_form_dialog.dart';

class FlowModal extends StatelessWidget {
  final StateProvider<String> categorySelectionProvider;
  final StateProvider<String> prioritySelectionProvider;
  final StateProvider<DateTime?> pickedDateProvider;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool toUpdate;
  final String? taskUniqueId;

  const FlowModal({
    super.key,
    required this.categorySelectionProvider,
    required this.prioritySelectionProvider,
    required this.pickedDateProvider,
    required this.titleController,
    required this.descriptionController,
    this.toUpdate = false,
    this.taskUniqueId,
  });

  @override
  Widget build(BuildContext context) {
    return TaskFormDialog(
      categorySelectionProvider: categorySelectionProvider,
      prioritySelectionProvider: prioritySelectionProvider,
      pickedDateProvider: pickedDateProvider,
      titleController: titleController,
      descriptionController: descriptionController,
      toUpdate: toUpdate,
      taskUniqueId: taskUniqueId,
    );
  }
}
