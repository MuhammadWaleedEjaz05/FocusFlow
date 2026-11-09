import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/core/routes/app_page_transitions.dart';
import 'package:frontend/features/auth/pages/login_screen.dart';
import 'package:frontend/features/auth/sections/auth_header_section.dart';
import 'package:frontend/features/auth/sections/reset_password_form_section.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/widgets/custom_back_button.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final controller = await ref.read(userProvider.future);
      await controller.resetPassword(
        widget.email,
        _passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password reset successfully! Please log in.'),
          backgroundColor: context.appColors.success,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        AppPageRoute.fadeScale(const LoginScreen()),
        (route) => false,
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
                icon: Icons.lock_open_rounded,
                title: AppLocalizations.of(context)!.resetPassword,
                subtitle:
                    AppLocalizations.of(context)!.resetPasswordDescription,
              ),
              32.verticalSpace,
              ResetPasswordFormSection(
                passwordController: _passwordController,
                formKey: _formKey,
                onSubmit: _handleResetPassword,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

