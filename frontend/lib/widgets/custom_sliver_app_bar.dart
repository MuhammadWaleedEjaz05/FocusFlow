import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';

class CustomSliverAppBar extends StatelessWidget {
  final double? height;
  final Widget children;
  final bool showBottomBorder;
  final Color? backgroundColor;
  final bool pinned;
  final bool floating;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomSliverAppBar({
    super.key,
    this.height,
    required this.children,
    this.showBottomBorder = false,
    this.backgroundColor,
    this.pinned = false,
    this.floating = false,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      expandedHeight: height ?? 80.h,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? context.appColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          alignment: Alignment.bottomLeft,
          child: children,
        ),
      ),
    );
  }
}

