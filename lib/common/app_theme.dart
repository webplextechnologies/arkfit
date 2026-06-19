import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    
    useMaterial3: false,
    brightness: Brightness.light,
    fontFamily: 'urbanist',
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      //foregroundColor: AppColors.text,
      titleTextStyle: AppTextStyles.appbarTitle,
      iconTheme: const IconThemeData(color: AppColors.text),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),

    dividerColor: Colors.black12,

    colorScheme: const ColorScheme.light(primary: Colors.white),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    fontFamily: 'urbanist',
    colorScheme: const ColorScheme.dark(primary: Colors.black),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      //foregroundColor: Colors.white,
      titleTextStyle: AppTextStyles.appbarDarkTitle,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
    ),
    dividerColor: Colors.white,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),
    //Colors.white24,
  );
}


/*appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
    ),

    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      titleLarge: AppTextStyles.titleLarge,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      labelLarge: AppTextStyles.button,
    ),

   
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),*/