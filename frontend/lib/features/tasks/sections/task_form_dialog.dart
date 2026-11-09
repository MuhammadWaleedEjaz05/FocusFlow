import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/task_model.dart';
import 'package:frontend/Providers/catergory_selection_provider.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/localdb_provider.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';
import 'package:frontend/widgets/custom_cupertino_date_picker.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';
import 'package:frontend/widgets/custom_label_text_field.dart';
import 'package:frontend/widgets/custom_outlined_button.dart';

class TaskFormDialog extends ConsumerStatefulWidget {
  final StateProvider<String> categorySelectionProvider;
  final StateProvider<String> prioritySelectionProvider;
  final StateProvider<DateTime?> pickedDateProvider;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool toUpdate;
  final String? taskUniqueId;

  const TaskFormDialog({
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
  ConsumerState<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends ConsumerState<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final isOnline = ref.read(isOnlineProvider);
    final isLoggedIn = ref.read(isLoggedInProvider);
    final useLocalDb = !isOnline || !isLoggedIn;
    final category = ref.read(widget.categorySelectionProvider);
    final priority = ref.read(widget.prioritySelectionProvider);
    final pickedDate = ref.read(widget.pickedDateProvider);

    try {
      final prefs = await ref.read(prefProvider.future);
      final userEmail = prefs.getString('userEmail') ?? '';

      final task = TaskModel(
        userEmail: userEmail,
        uniqueId: widget.toUpdate
            ? widget.taskUniqueId!
            : DateTime.now().millisecondsSinceEpoch.toString(),
        title: widget.titleController.text.trim(),
        description: widget.descriptionController.text.trim(),
        category: category.isNotEmpty ? category : 'work',
        priority: priority.isNotEmpty ? priority : 'medium',
        dueDate: pickedDate ?? DateTime.now(),
      );

      if (useLocalDb) {
        final localDb = await ref.read(localDBProvider.future);
        if (widget.toUpdate) {
          await localDb.updateLocalTask(task);
        } else {
          await localDb.addLocalTask(task);
        }
      } else {
        final taskRepo = await ref.read(taskProvider.future);
        if (widget.toUpdate) {
          await taskRepo.updateTask(task);
        } else {
          await taskRepo.addTask(task);
        }
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving task: $e'),
          backgroundColor: context.appColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(widget.categorySelectionProvider);
    final pickedDate = ref.watch(widget.pickedDateProvider);

    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: widget.toUpdate
                          ? AppLocalizations.of(context)!.updateTask
                          : AppLocalizations.of(context)!.newTask,
                      style: AppTextStyles.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 20.r,
                        color: context.appColors.onSurfaceVariant,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 32.r,
                        minHeight: 32.r,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                CustomLabelTextField(
                  label: AppLocalizations.of(context)!.taskTitle,
                  hintText: AppLocalizations.of(context)!.taskTitleDetails,
                  controller: widget.titleController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter task title';
                    }
                    return null;
                  },
                ),
                14.verticalSpace,
                CustomLabelTextField(
                  label: AppLocalizations.of(context)!.description,
                  hintText: AppLocalizations.of(context)!.descriptiondetails,
                  controller: widget.descriptionController,
                  maxLines: 3,
                ),
                16.verticalSpace,
                AppText(
                  text: AppLocalizations.of(context)!.category,
                  style: AppTextStyles.labelMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: categories.skip(1).map((cat) {
                    final isSelected =
                        selectedCategory.toLowerCase() == cat.toLowerCase();
                    return ChoiceChip(
                      label: AppText(
                        text: cat,
                        style: AppTextStyles.labelSmall(context).copyWith(
                          color: isSelected
                              ? context.appColors.onPrimary
                              : context.appColors.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: context.appColors.primary,
                      backgroundColor: context.appColors.surface,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          color: isSelected
                              ? context.appColors.primary
                              : context.appColors.border,
                        ),
                      ),
                      onSelected: (selected) {
                        ref
                            .read(widget.categorySelectionProvider.notifier)
                            .state = selected ? cat.toLowerCase() : '';
                      },
                    );
                  }).toList(),
                ),
                16.verticalSpace,
                AppText(
                  text: AppLocalizations.of(context)!.priority,
                  style: AppTextStyles.labelMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                Row(
                  children: [
                    _buildPriorityButton('low', 'Low', context.appColors.success),
                    8.horizontalSpace,
                    _buildPriorityButton(
                      'medium',
                      'Medium',
                      context.appColors.warning,
                    ),
                    8.horizontalSpace,
                    _buildPriorityButton('high', 'High', context.appColors.error),
                  ],
                ),
                16.verticalSpace,
                AppText(
                  text: AppLocalizations.of(context)!.dueDate,
                  style: AppTextStyles.labelMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                InkWell(
                  onTap: () async {
                    final tomorrow = DateTime.now().add(const Duration(days: 1));
                    final picked = await showCustomCupertinoDatePickerSheet(
                      context,
                      initialDate: pickedDate ?? tomorrow,
                      minimumDate: DateTime.now().subtract(const Duration(days: 30)),
                      maximumDate: DateTime(2100),
                      title: AppLocalizations.of(context)!.dueDate,
                    );
                    if (picked != null) {
                      ref.read(widget.pickedDateProvider.notifier).state = picked;
                    }
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.appColors.border),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 18.r,
                          color: context.appColors.primary,
                        ),
                        10.horizontalSpace,
                        AppText(
                          text: pickedDate != null
                              ? pickedDate.toString().split(' ')[0]
                              : 'Select due date',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ],
                    ),
                  ),
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        text: AppLocalizations.of(context)!.cancel,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: CustomElevatedButton(
                        text: AppLocalizations.of(context)!.save,
                        onPressed: _handleSave,
                        isLoading: _isSaving,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String value, String label, Color color) {
    final isSelected =
        ref.watch(widget.prioritySelectionProvider).toLowerCase() == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(widget.prioritySelectionProvider.notifier).state = value;
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.3),
            ),
          ),
          alignment: Alignment.center,
          child: AppText(
            text: label,
            style: AppTextStyles.labelMedium(context).copyWith(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
