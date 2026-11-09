import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';
import 'package:frontend/widgets/custom_label_text_field.dart';
import 'package:frontend/widgets/custom_outlined_button.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final prefs = await ref.read(prefProvider.future);
    final userEmail = prefs.getString('userEmail') ?? '';

    try {
      await ref
          .read(userServiceProvider)
          .loginUser(userEmail, _oldPasswordController.text.trim());

      final user = await ref.read(fetchuserProvider(userEmail).future);
      final userController = await ref.read(userProvider.future);
      await userController.updateUser(
        user.copyWith(password: _newPasswordController.text.trim()),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password changed successfully!'),
          backgroundColor: context.appColors.success,
        ),
      );
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Old password is incorrect'),
          backgroundColor: context.appColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 380.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: AppLocalizations.of(context)!.changePassword,
                  style: AppTextStyles.titleLarge(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.verticalSpace,
                CustomLabelTextField(
                  label: AppLocalizations.of(context)!.oldPassword,
                  hintText: AppLocalizations.of(context)!.oldPassworddescription,
                  controller: _oldPasswordController,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter old password';
                    }
                    return null;
                  },
                ),
                14.verticalSpace,
                CustomLabelTextField(
                  label: AppLocalizations.of(context)!.newPassword,
                  hintText: AppLocalizations.of(context)!.newPassworddescription,
                  controller: _newPasswordController,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                14.verticalSpace,
                CustomLabelTextField(
                  label: AppLocalizations.of(context)!.confirmNewPassword,
                  hintText:
                      AppLocalizations.of(context)!.confirmNewPassworddescription,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (val) {
                    if (val != _newPasswordController.text) {
                      return 'Passwords do not match';
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
}

