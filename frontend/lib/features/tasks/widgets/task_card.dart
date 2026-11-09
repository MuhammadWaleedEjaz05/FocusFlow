import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/features/tasks/sections/task_form_dialog.dart';
import 'package:frontend/features/tasks/widgets/task_due_date_chip.dart';
import 'package:frontend/features/tasks/widgets/task_label_chip.dart';
import 'package:frontend/widgets/app_text.dart';

final _cardCategoryProvider = StateProvider<String>((ref) => '');
final _cardPriorityProvider = StateProvider<String>((ref) => '');
final _cardDateProvider = StateProvider<DateTime?>((ref) => null);

class TaskCard extends ConsumerWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  Color _getPriorityColor(String priority, BuildContext context) {
    switch (priority.toLowerCase()) {
      case 'high':
        return context.appColors.error;
      case 'medium':
        return context.appColors.warning;
      case 'low':
      default:
        return context.appColors.success;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    final isOnline = ref.watch(isOnlineProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final useLocalDb = !isOnline || !isLoggedIn;

    TaskModel currentTask = task;
    if (!useLocalDb) {
      final tasksAsync = ref.watch(tasksListProvider(task.userEmail));
      currentTask = tasksAsync.maybeWhen(
        data: (tasks) {
          try {
            return tasks.firstWhere((t) => t.uniqueId == task.uniqueId);
          } catch (_) {
            return task;
          }
        },
        orElse: () => task,
      );
    }

    final priorityColor = _getPriorityColor(currentTask.priority, context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: currentTask.isCompleted
              ? context.appColors.border.withValues(alpha: 0.5)
              : context.appColors.border,
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.08),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          childrenPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
          leading: IconButton(
            onPressed: () async {
              final updated = currentTask.copyWith(
                isCompleted: !currentTask.isCompleted,
              );
              if (useLocalDb) {
                final localDb = await ref.read(localDBProvider.future);
                await localDb.updateLocalTask(updated);
              } else {
                final taskController = await ref.read(taskProvider.future);
                await taskController.updateTask(updated);
              }
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                currentTask.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                key: ValueKey<bool>(currentTask.isCompleted),
                size: 24.r,
                color: currentTask.isCompleted
                    ? context.appColors.success
                    : context.appColors.onSurfaceVariant,
              ),
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32.r, minHeight: 32.r),
          ),
          title: AppText(
            text: currentTask.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium(context).copyWith(
              color: currentTask.isCompleted
                  ? context.appColors.onSurfaceVariant
                  : context.appColors.onSurface,
              decoration: currentTask.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentTask.description.isNotEmpty) ...[
                4.verticalSpace,
                AppText(
                  text: currentTask.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: currentTask.isCompleted
                        ? context.appColors.onSurfaceVariant
                            .withValues(alpha: 0.7)
                        : context.appColors.onSurfaceVariant,
                  ),
                ),
              ],
              8.verticalSpace,
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                children: [
                  TaskLabelChip(
                    label: currentTask.category,
                    color: context.appColors.primary,
                  ),
                  TaskLabelChip(
                    label: currentTask.priority,
                    color: priorityColor,
                  ),
                  TaskDueDateChip(dueDate: currentTask.dueDate),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () async {
              final localDb = await ref.read(localDBProvider.future);
              if (currentTask.isFavorite) {
                await localDb.removeFromFavourites(currentTask);
              } else {
                await localDb.addtoFavourites(currentTask);
              }
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                currentTask.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey<bool>(currentTask.isFavorite),
                size: 22.r,
                color: currentTask.isFavorite
                    ? context.appColors.error
                    : context.appColors.onSurfaceVariant,
              ),
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32.r, minHeight: 32.r),
          ),
          children: [
            Divider(color: context.appColors.border, height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(_cardCategoryProvider.notifier).state =
                          currentTask.category;
                      ref.read(_cardPriorityProvider.notifier).state =
                          currentTask.priority;
                      ref.read(_cardDateProvider.notifier).state =
                          currentTask.dueDate;
                      showDialog(
                        context: context,
                        builder: (_) => TaskFormDialog(
                          categorySelectionProvider: _cardCategoryProvider,
                          prioritySelectionProvider: _cardPriorityProvider,
                          pickedDateProvider: _cardDateProvider,
                          titleController: titleController,
                          descriptionController: descriptionController,
                          toUpdate: true,
                          taskUniqueId: currentTask.uniqueId,
                        ),
                      );
                    },
                    icon: Icon(Icons.edit_outlined, size: 16.r),
                    label: AppText(
                      text: 'Edit',
                      style: AppTextStyles.labelMedium(context),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.appColors.primary,
                      side: BorderSide(color: context.appColors.border),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final prefs = await ref.read(prefProvider.future);
                      final userEmail = prefs.getString('userEmail') ?? '';
                      if (!useLocalDb) {
                        final taskController =
                            await ref.read(taskProvider.future);
                        await taskController.deleteTask(
                          currentTask.copyWith(userEmail: userEmail),
                        );
                      } else {
                        final localDb = await ref.read(localDBProvider.future);
                        await localDb.deleteLocalTask(currentTask);
                      }
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 16.r,
                      color: context.appColors.error,
                    ),
                    label: AppText(
                      text: 'Delete',
                      style: AppTextStyles.labelMedium(context).copyWith(
                        color: context.appColors.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.appColors.error,
                      side: BorderSide(
                        color: context.appColors.error.withValues(alpha: 0.3),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

