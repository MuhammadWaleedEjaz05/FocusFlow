import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/core/routes/app_page_transitions.dart';
import 'package:frontend/features/auth/pages/login_screen.dart';
import 'package:frontend/features/auth/sections/auth_header_section.dart';
import 'package:frontend/features/auth/sections/signup_actions_section.dart';
import 'package:frontend/features/auth/sections/signup_form_section.dart';
import 'package:frontend/l10n/app_localizations.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = UserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
      );

      final controller = await ref.read(userProvider.future);
      await controller.registerUser(user);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account created successfully! Please log in.'),
          backgroundColor: context.appColors.success,
        ),
      );
      Navigator.pushReplacement(
        context,
        AppPageRoute.fadeScale(const LoginScreen()),
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
                icon: Icons.person_add_rounded,
                title: AppLocalizations.of(context)!.createAccount,
                subtitle: AppLocalizations.of(context)!.signUpStatment,
              ),
              28.verticalSpace,
              SignupFormSection(
                fullNameController: _fullNameController,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                formKey: _formKey,
              ),
              24.verticalSpace,
              SignupActionsSection(
                onSignupPressed: _handleSignup,
                onLoginNavigate: () {
                  Navigator.pushReplacement(
                    context,
                    AppPageRoute.fadeScale(const LoginScreen()),
                  );
                },
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

