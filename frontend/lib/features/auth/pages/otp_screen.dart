import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/core/routes/app_page_transitions.dart';
import 'package:frontend/features/auth/pages/reset_password_screen.dart';
import 'package:frontend/features/auth/sections/auth_header_section.dart';
import 'package:frontend/features/auth/sections/otp_form_section.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/widgets/custom_back_button.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  Future<void> _handleOtpSubmit(String otpCode) async {
    try {
      final controller = await ref.read(userProvider.future);
      await controller.verifyOTP(widget.email, otpCode);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Code verified successfully!'),
          backgroundColor: context.appColors.success,
        ),
      );
      Navigator.pushReplacement(
        context,
        AppPageRoute.slideUp(ResetPasswordScreen(email: widget.email)),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().contains(': ')
          ? e.toString().split(': ').last
          : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.appColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: const CustomAppBar(leading: CustomBackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              20.verticalSpace,
              AuthHeaderSection(
                icon: Icons.mark_email_read_rounded,
                title: AppLocalizations.of(context)!.enterVerificationCode,
                subtitle: AppLocalizations.of(context)!
                    .enterVerificationCodeDescription,
              ),
              32.verticalSpace,
              OtpFormSection(onCodeSubmitted: _handleOtpSubmit),
            ],
          ),
        ),
      ),
    );
  }
}

