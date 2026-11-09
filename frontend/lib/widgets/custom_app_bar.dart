import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/widgets/app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool showBottomBorder;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.appColors.surface,
        border: showBottomBorder
            ? Border(
                bottom: BorderSide(
                  color: context.appColors.border,
                  width: 1.r,
                ),
              )
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              if (leading != null) leading!,
              if (leading != null && (title != null || titleWidget != null))
                12.horizontalSpace,
              if (titleWidget != null)
                Expanded(child: titleWidget!)
              else if (title != null)
                Expanded(
                  child: AppText(
                    text: title!,
                    style: AppTextStyles.titleLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                  ),
                )
              else
                const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}

