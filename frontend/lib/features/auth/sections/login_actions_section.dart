import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/auth/widgets/auth_switch_mode_row.dart';
import 'package:frontend/features/auth/widgets/google_sign_in_button.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';

class LoginActionsSection extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onGooglePressed;
  final VoidCallback onSignUpNavigate;
  final bool isLoading;
  final bool isGoogleLoading;

  const LoginActionsSection({
    super.key,
    required this.onLoginPressed,
    required this.onGooglePressed,
    required this.onSignUpNavigate,
    this.isLoading = false,
    this.isGoogleLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: AppLocalizations.of(context)!.login,
          onPressed: onLoginPressed,
          isLoading: isLoading,
        ),
        14.verticalSpace,
        GoogleSignInButton(
          onPressed: onGooglePressed,
          isLoading: isGoogleLoading,
        ),
        20.verticalSpace,
        AuthSwitchModeRow(
          questionText: AppLocalizations.of(context)!.dontHaveAccount,
          actionText: AppLocalizations.of(context)!.signUp,
          onActionPressed: onSignUpNavigate,
        ),
      ],
    );
  }
}

