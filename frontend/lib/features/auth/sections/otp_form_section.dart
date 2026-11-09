import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';

class OtpFormSection extends StatelessWidget {
  final ValueChanged<String> onCodeSubmitted;

  const OtpFormSection({
    super.key,
    required this.onCodeSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.appColors.border),
      ),
      child: OtpTextField(
        numberOfFields: 6,
        showFieldAsBox: true,
        fieldWidth: 44.w,
        borderRadius: BorderRadius.circular(10.r),
        borderColor: context.appColors.border,
        focusedBorderColor: context.appColors.primary,
        cursorColor: context.appColors.primary,
        textStyle: AppTextStyles.titleMedium(context).copyWith(
          fontWeight: FontWeight.bold,
        ),
        onSubmit: onCodeSubmitted,
      ),
    );
  }
}

