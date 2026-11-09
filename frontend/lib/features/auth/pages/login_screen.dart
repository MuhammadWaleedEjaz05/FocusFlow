import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/core/routes/app_page_transitions.dart';
import 'package:frontend/features/auth/pages/forgot_password_screen.dart';
import 'package:frontend/features/auth/pages/signup_screen.dart';
import 'package:frontend/features/auth/sections/auth_header_section.dart';
import 'package:frontend/features/auth/sections/login_actions_section.dart';
import 'package:frontend/features/auth/sections/login_form_section.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final controller = await ref.read(userProvider.future);
      await controller.loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login Successful!'),
          backgroundColor: context.appColors.success,
        ),
      );
      Navigator.of(context).pop();
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

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final controller = await ref.read(userProvider.future);
        await controller.googleSignIn(idToken, googleUser.email);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Google Login Successful!'),
            backgroundColor: context.appColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In Failed: $e'),
          backgroundColor: context.appColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              24.verticalSpace,
              AuthHeaderSection(
                icon: Icons.login_rounded,
                title: AppLocalizations.of(context)!.welcomeBack,
                subtitle: AppLocalizations.of(context)!.loginStatment,
              ),
              28.verticalSpace,
              LoginFormSection(
                emailController: _emailController,
                passwordController: _passwordController,
                formKey: _formKey,
                onForgotPassword: () {
                  Navigator.push(
                    context,
                    AppPageRoute.fadeScale(const ForgotPasswordScreen()),
                  );
                },
              ),
              24.verticalSpace,
              LoginActionsSection(
                onLoginPressed: _handleLogin,
                onGooglePressed: _handleGoogleSignIn,
                onSignUpNavigate: () {
                  Navigator.pushReplacement(
                    context,
                    AppPageRoute.fadeScale(const SignupScreen()),
                  );
                },
                isLoading: _isLoading,
                isGoogleLoading: _isGoogleLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

