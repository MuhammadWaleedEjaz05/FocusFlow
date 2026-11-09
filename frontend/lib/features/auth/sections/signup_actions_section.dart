import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/features/auth/widgets/auth_switch_mode_row.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';

class SignupActionsSection extends StatelessWidget {
  final VoidCallback onSignupPressed;
  final VoidCallback onLoginNavigate;
  final bool isLoading;

  const SignupActionsSection({
    super.key,
    required this.onSignupPressed,
    required this.onLoginNavigate,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: AppLocalizations.of(context)!.signUp,
          onPressed: onSignupPressed,
          isLoading: isLoading,
        ),
        20.verticalSpace,
        AuthSwitchModeRow(
          questionText: AppLocalizations.of(context)!.haveAccount,
          actionText: AppLocalizations.of(context)!.login,
          onActionPressed: onLoginNavigate,
        ),
      ],
    );
  }
}

