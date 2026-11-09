import 'package:flutter/material.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/widgets/app_text.dart';

class AuthSwitchModeRow extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthSwitchModeRow({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          text: questionText,
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: context.appColors.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: onActionPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: context.appColors.primary,
          ),
          child: AppText(
            text: ' $actionText',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: context.appColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

