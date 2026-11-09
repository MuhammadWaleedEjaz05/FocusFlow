import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';
import 'package:frontend/widgets/custom_label_text_field.dart';

class ResetPasswordFormSection extends StatefulWidget {
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final bool isLoading;

  const ResetPasswordFormSection({
    super.key,
    required this.passwordController,
    required this.formKey,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ResetPasswordFormSection> createState() =>
      _ResetPasswordFormSectionState();
}

class _ResetPasswordFormSectionState extends State<ResetPasswordFormSection> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomLabelTextField(
            label: AppLocalizations.of(context)!.newPassword,
            hintText: '••••••••',
            controller: widget.passwordController,
            obscureText: !_isPasswordVisible,
            prefix: Icon(
              Icons.lock_outline_rounded,
              size: 20.r,
              color: context.appColors.onSurfaceVariant,
            ),
            suffix: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20.r,
                color: context.appColors.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          24.verticalSpace,
          CustomElevatedButton(
            text: AppLocalizations.of(context)!.resetPassword,
            onPressed: widget.onSubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}

