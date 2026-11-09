import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20.r,
        color: color ?? context.appColors.onSurface,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: 40.r,
        minHeight: 40.r,
      ),
    );
  }
}

