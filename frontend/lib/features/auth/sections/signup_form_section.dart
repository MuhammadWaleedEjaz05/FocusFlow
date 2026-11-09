import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_label_text_field.dart';

class SignupFormSection extends StatefulWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  const SignupFormSection({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  @override
  State<SignupFormSection> createState() => _SignupFormSectionState();
}

class _SignupFormSectionState extends State<SignupFormSection> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomLabelTextField(
            label: AppLocalizations.of(context)!.fullName,
            hintText: 'John Doe',
            controller: widget.fullNameController,
            prefix: Icon(
              Icons.person_outline_rounded,
              size: 20.r,
              color: context.appColors.onSurfaceVariant,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          14.verticalSpace,
          CustomLabelTextField(
            label: AppLocalizations.of(context)!.email,
            hintText: 'you@example.com',
            controller: widget.emailController,
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
          14.verticalSpace,
          CustomLabelTextField(
            label: AppLocalizations.of(context)!.password,
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
          14.verticalSpace,
          CustomLabelTextField(
            label: AppLocalizations.of(context)!.confirmPassword,
            hintText: '••••••••',
            controller: widget.confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            prefix: Icon(
              Icons.lock_outline_rounded,
              size: 20.r,
              color: context.appColors.onSurfaceVariant,
            ),
            suffix: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20.r,
                color: context.appColors.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

