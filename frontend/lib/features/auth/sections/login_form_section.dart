import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';
import 'package:frontend/widgets/custom_label_text_field.dart';

class LoginFormSection extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onForgotPassword;

  const LoginFormSection({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onForgotPassword,
  });

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          16.verticalSpace,
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
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          8.verticalSpace,
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: context.appColors.primary,
              ),
              child: AppText(
                text: AppLocalizations.of(context)!.forgotPassword,
                style: AppTextStyles.labelMedium(context).copyWith(
                  color: context.appColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

