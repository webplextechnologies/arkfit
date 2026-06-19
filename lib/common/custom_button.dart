import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  String? title;
  IconData? icon;
  final VoidCallback? onPressed;

  CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    return SizedBox(
      width: double.infinity,
      height: 50.h,

      child: ElevatedButton(
        //onPressed: () => onPressed(),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors
                    .grey
                    .shade400 // 👈 disabled color
              : AppColors.primary,
          // backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? Icon(icon, color: Colors.white) : SizedBox(),
            Text(title ?? '', style: AppTextStyles.button),
          ],
        ),
      ),
    );
  }
}
