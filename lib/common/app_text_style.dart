import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static  TextStyle headling = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
    //color: AppColors.textPrimary,
  );

  static TextStyle subHeading(BuildContext context) {
  return TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.textSecondary,
  );
}



  static  TextStyle text = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );


  static  TextStyle headlineLarge = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static  TextStyle headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
   static  TextStyle headlineMediumDark = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static  TextStyle titleLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static  TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    color: AppColors.textPrimary,
  );

  static  TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    color: AppColors.textSecondary,
  );

  static  TextStyle button = TextStyle(
      fontFamily: 'urbanist',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
    static  TextStyle appbarTitle = TextStyle(
    fontFamily: 'urbanist',
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
   static  TextStyle appbarDarkTitle = TextStyle(
    fontFamily: 'urbanist',
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
