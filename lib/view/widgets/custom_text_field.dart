import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final bool showFocusBorder;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.onChanged,
    this.fillColor,
    this.showFocusBorder = true,
    this.maxLength,
  });

  OutlineInputBorder _border(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color borderColor;
          borderColor = color ?? (isDark ? Colors.white : Colors.transparent);


    // if (!showFocusBorder && !isDark) {
    //   // 👈 Light mode + focus border disabled
    //   borderColor = Colors.black12;
    // } else {
    //   // Default behavior
    //   borderColor = color ?? (isDark ? Colors.white : Colors.transparent);
    // }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: borderColor, width: 1.2.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
           SizedBox(height: 6.h),
        ],
        TextFormField(
          maxLength: maxLength,
          obscuringCharacter: "*",
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          onChanged: onChanged,
        
          //style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          cursorColor: AppColors.primary,

          // style: TextStyle(
          //   fontSize: 18.sp,
          //   letterSpacing: obscureText == true ? 2 : 0,
          //   color: Colors.black,
          //   fontWeight: FontWeight.w600,
          // ),
          style: TextStyle(
            fontSize: 17.sp,
            letterSpacing: obscureText == true ? 2 : 0,
            color:(fillColor == Colors.grey.shade100 ||
          fillColor == Colors.white)
                ? Colors.black // White background → black text
                : Theme.of(context).brightness == Brightness.dark
                ? Colors.white // Dark mode → white text
                : Colors.black, // Light mode → black text
            fontWeight: FontWeight.w600,
          ),

          decoration: InputDecoration(
            counterText: "",
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 0,
              fontSize: 17.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: prefixIcon,

            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor,
            //Colors.grey.shade100
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 12.w,
            ),

            border: _border(context),
            enabledBorder: _border(context),
            focusedBorder: showFocusBorder
                ? _border(context, color: Colors.green)
                : _border(context),
            errorBorder: _border(context, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
