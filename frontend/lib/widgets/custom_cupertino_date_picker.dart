import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/app/theme/app_text_styles.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';
import 'package:frontend/widgets/app_text.dart';

Future<DateTime?> showCustomCupertinoDatePickerSheet(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? minimumDate,
  DateTime? maximumDate,
  String title = 'Select Date',
}) async {
  DateTime tempDate = initialDate;

  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (BuildContext popupContext) {
      return Container(
        height: 310.h,
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Header bar with Cancel / Title / Done
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.appColors.border,
                    width: 0.8.r,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(popupContext).pop(null),
                    child: AppText(
                      text: 'Cancel',
                      style: AppTextStyles.labelLarge(context).copyWith(
                        color: context.appColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  AppText(
                    text: title,
                    style: AppTextStyles.titleSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(popupContext).pop(tempDate),
                    child: AppText(
                      text: 'Done',
                      style: AppTextStyles.labelLarge(context).copyWith(
                        color: context.appColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Cupertino Date Picker Wheel
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Theme.of(context).brightness,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle:
                        AppTextStyles.titleMedium(context).copyWith(
                      color: context.appColors.onSurface,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  minimumDate: minimumDate ?? DateTime(2020),
                  maximumDate: maximumDate ?? DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

