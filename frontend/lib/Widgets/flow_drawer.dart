import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/Providers/connectivity_provider.dart';
import 'package:frontend/Providers/screen_navigation_provider.dart';
import 'package:frontend/Providers/user_provider.dart';
import 'package:frontend/Screens/login_screen.dart';
import 'package:frontend/Screens/signup_screen.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/core/routes/app_page_transitions.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/widgets/app_text.dart';

class FlowDrawer extends ConsumerWidget {
  const FlowDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSelection = ref.watch(screenNavigationProvider);
    final isLoggedIn = ref.watch(prefProvider).maybeWhen(
          data: (prefs) => prefs.getBool('isLoggedIn') ?? false,
          orElse: () => false,
        );
    final userEmail = ref.watch(prefProvider).maybeWhen(
          data: (prefs) => prefs.getString('userEmail') ?? '',
          orElse: () => '',
        );
    final userAsync = ref.watch(fetchuserProvider(userEmail));
    final userData = userAsync.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
    final isOnline = ref.watch(isOnlineProvider);

    return Drawer(
      backgroundColor: context.appColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.appColors.primary,
                  context.appColors.primary,
                  context.appColors.primaryLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: isOnline
                ? isLoggedIn
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: Icon(
                              Icons.person_rounded,
                              size: 36.r,
                              color: Colors.white,
                            ),
                          ),
                          10.verticalSpace,
                          if (userAsync.isLoading)
                            SizedBox(
                              height: 16.r,
                              width: 16.r,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          else
                            AppText(
                              text: userData?.fullName ?? 'Guest',
                              style: AppTextStyles.titleMedium(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140.w,
                            height: 38.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  AppPageRoute.fadeScale(const LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: context.appColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: AppText(
                                text: AppLocalizations.of(context)!.login,
                                style: AppTextStyles.labelMedium(context).copyWith(
                                  color: context.appColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          8.verticalSpace,
                          SizedBox(
                            width: 140.w,
                            height: 38.h,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  AppPageRoute.fadeScale(const SignupScreen()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: AppText(
                                text: AppLocalizations.of(context)!.signUp,
                                style: AppTextStyles.labelMedium(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                : Center(
                    child: AppText(
                      text: 'Offline Mode',
                      style: AppTextStyles.titleMedium(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            shrinkWrap: true,
            itemCount: screens(context).length,
            itemBuilder: (context, index) => FlowDrawerItem(
              title: screens(context)[index].screenName,
              icon: screens(context)[index].screenIcon,
              isSelected: screenSelection == index,
              onTap: () {
                ref.read(screenNavigationProvider.notifier).state = index;
                Navigator.pushReplacement(
                  context,
                  AppPageRoute.fadeScale(
                    screens(context)[index].screenWidget,
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          if (isLoggedIn)
            Padding(
              padding: EdgeInsets.all(16.r),
              child: ListTile(
                tileColor: context.appColors.error.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: context.appColors.error.withValues(alpha: 0.3),
                  ),
                ),
                leading: Icon(
                  Icons.logout_rounded,
                  size: 22.r,
                  color: context.appColors.error,
                ),
                title: AppText(
                  text: AppLocalizations.of(context)!.logout,
                  style: AppTextStyles.labelLarge(context).copyWith(
                    color: context.appColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  final controller = await ref.read(userProvider.future);
                  await controller.logoutUser();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              ),
            ),
        ],
      ),
    );
  }
}

class FlowDrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;

  const FlowDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ListTile(
        tileColor: isSelected
            ? context.appColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: isSelected
              ? BorderSide(
                  color: context.appColors.primary.withValues(alpha: 0.4),
                  width: 1.r,
                )
              : BorderSide.none,
        ),
        leading: Icon(
          icon,
          size: 22.r,
          color: isSelected
              ? context.appColors.primary
              : context.appColors.onSurfaceVariant,
        ),
        title: AppText(
          text: title,
          style: AppTextStyles.bodyMedium(context).copyWith(
            color: isSelected
                ? context.appColors.primary
                : context.appColors.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
