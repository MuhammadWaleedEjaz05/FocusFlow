import 'package:flutter/material.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/features/tasks/widgets/task_card.dart';

export 'package:frontend/features/tasks/widgets/task_card.dart';

class FlowTaskItem extends StatelessWidget {
  final TaskModel task;
  const FlowTaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return TaskCard(task: task);
  }
}
