import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';
import 'package:frontend/widgets/custom_label_text_field.dart';

class ForgotPasswordFormSection extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final bool isLoading;

  const ForgotPasswordFormSection({
    super.key,
    required this.emailController,
    required this.formKey,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomLabelTextField(
            label: AppLocalizations.of(context)!.email,
            hintText: 'you@example.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefix: Icon(
              Icons.mail_outline_rounded,
              size: 20.r,
              color: context.appColors.onSurfaceVariant,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          24.verticalSpace,
          CustomElevatedButton(
            text: AppLocalizations.of(context)!.save,
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

