import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/core/routes/app_page_transitions.dart';
import 'package:frontend/features/auth/pages/otp_screen.dart';
import 'package:frontend/features/auth/sections/auth_header_section.dart';
import 'package:frontend/features/auth/sections/forgot_password_form_section.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/widgets/custom_back_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    try {
      final controller = await ref.read(userProvider.future);
      await controller.sendOTP(email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP sent successfully! Check your inbox.'),
          backgroundColor: context.appColors.success,
        ),
      );
      Navigator.push(
        context,
        AppPageRoute.slideUp(OtpScreen(email: email)),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().contains(': ')
          ? e.toString().split(': ')[1]
          : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.appColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                icon: Icons.lock_reset_rounded,
                title: AppLocalizations.of(context)!.forgotPassword,
                subtitle:
                    AppLocalizations.of(context)!.forgotPasswordDescription,
              ),
              32.verticalSpace,
              ForgotPasswordFormSection(
                emailController: _emailController,
                formKey: _formKey,
                onSubmit: _handleSubmit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
