import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDatePicker {
  static Future<DateTime?> pickDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: Colors.white,

              dayForegroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
              ),
              dayBackgroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? AppColors.primary
                    : Colors.transparent,
              ),

              todayForegroundColor: MaterialStateProperty.all(
                isDark ? Colors.white : AppColors.primary,
              ),
              todayBackgroundColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              todayBorder: BorderSide(color: AppColors.primary, width: 1.5),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),

          child: child!,
        );
      },
    );

    return picked;
  }
}
