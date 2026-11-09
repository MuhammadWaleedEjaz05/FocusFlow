import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';
import 'package:frontend/widgets/custom_elevated_button.dart';
import 'package:frontend/widgets/custom_outlined_button.dart';

class ConfirmDeleteDialog extends ConsumerStatefulWidget {
  const ConfirmDeleteDialog({super.key});

  @override
  ConsumerState<ConfirmDeleteDialog> createState() =>
      _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends ConsumerState<ConfirmDeleteDialog> {
  bool _isDeleting = false;

  Future<void> _handleDelete() async {
    setState(() => _isDeleting = true);
    try {
      final prefs = await ref.read(prefProvider.future);
      final email = prefs.getString('userEmail');
      if (email != null) {
        final controller = await ref.read(userProvider.future);
        await controller.deleteUser(email);
      }
      await prefs.setBool('isLoggedIn', false);
      ref.read(isLoggedInProvider.notifier).state = false;

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account: $e'),
          backgroundColor: context.appColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 360.w),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: context.appColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 22.r,
                      color: context.appColors.error,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: AppText(
                      text: AppLocalizations.of(context)!.deleteAccount,
                      style: AppTextStyles.titleMedium(context).copyWith(
                        color: context.appColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              14.verticalSpace,
              AppText(
                text: AppLocalizations.of(context)!.deleteAccountDescription,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: context.appColors.onSurfaceVariant,
                ),
              ),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      text: AppLocalizations.of(context)!.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: CustomElevatedButton(
                      text: AppLocalizations.of(context)!.deleteAccount,
                      backgroundColor: context.appColors.error,
                      onPressed: _handleDelete,
                      isLoading: _isDeleting,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

