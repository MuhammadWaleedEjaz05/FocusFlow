import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';
import 'package:frontend/widgets/custom_label_text_field.dart';
import 'package:frontend/widgets/custom_outlined_button.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  const EditProfileDialog({super.key});

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isSaving = false;
  bool _initialized = false;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate() || _currentUser == null) return;

    setState(() => _isSaving = true);
    try {
      final updated = _currentUser!.copyWith(
        fullName: _nameController.text.trim(),
      );
      final controller = await ref.read(userProvider.future);
      await controller.updateUser(updated);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: context.appColors.success,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: $e'),
          backgroundColor: context.appColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ref.watch(prefProvider).maybeWhen(
          data: (p) => p.getString('userEmail') ?? '',
          orElse: () => '',
        );

    final userAsync = userEmail.isNotEmpty
        ? ref.watch(fetchuserProvider(userEmail))
        : const AsyncValue<UserModel>.loading();

    userAsync.whenData((user) {
      if (!_initialized) {
        _currentUser = user;
        _nameController.text = user.fullName;
        _initialized = true;
      }
    });

    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 380.w),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: AppLocalizations.of(context)!.profile,
                  style: AppTextStyles.titleLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                CustomLabelTextField(
                  label: AppLocalizations.of(context)!.newName,
                  hintText: AppLocalizations.of(context)!.newNamedescription,
                  controller: _nameController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
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
                        onPressed: _handleUpdate,
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
}

