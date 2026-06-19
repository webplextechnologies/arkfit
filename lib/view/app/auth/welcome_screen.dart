import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/auth/controller/auth_controller.dart';
import 'package:ark_fit_gym/view/app/auth/login_screen.dart';
import 'package:ark_fit_gym/view/app/auth/sign_up_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(),

              /// Logo
              SizedBox(
                width: 80.w,
                height: 70.h,
                child: Image.asset(
                  "assets/icons/icon.png",
                  fit: BoxFit.contain,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.primary,
                ),
              ),

              SizedBox(height: 24.w),

              /// Title
              Text(
                tr("get_started"),
                style: AppTextStyles.headling.copyWith(fontSize: 24.sp),
              ),

              SizedBox(height: 8.w),

              /// Subtitle
              Text(
                tr("dive_account"),
                style: AppTextStyles.subHeading(
                  context,
                ).copyWith(fontSize: 14.sp),
              ),

              SizedBox(height: 40.w),

              /// Google
              /*  _socialButton(
                asset: "assets/icons/google.png",
                title: tr("google_login"),
                onTap: () {
                   authController.signInWithGoogle();
                },
              ), */
              SizedBox(height: 18.w),

              /// Apple
              /*   _socialButton(
                asset: "assets/icons/apple.png",
                title: "Continue with Apple",
                onTap: () {},
              ), */

              // SizedBox(height: 16.h),

              /// Facebook
              /*  _socialButton(
                asset: "assets/icons/facebook.png",
                title: tr("facebook_login"),
                onTap: () {},
              ),

              SizedBox(height: 18.w), */

              /*_socialButton(
                asset: "assets/icons/x.png",
                title: "Continue with X",
                onTap: () {},
              ),*/

              // SizedBox(height: 32.w),

              /// Sign Up
              CustomButton(
                title: tr("sign_up"),
                onPressed: () {
                  Get.to(() => SignUpScreen());
                },
              ),

              SizedBox(height: 18.w),

              /// Sign In
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => LoginScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).iconTheme.color!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    tr("sign_in"),
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              /// Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr("privacy_policy"),
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "•",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    tr("terms_of_service"),
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required String asset,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          side: BorderSide(color: Theme.of(Get.context!).iconTheme.color!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 35.w,
              height: 20.h,
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
