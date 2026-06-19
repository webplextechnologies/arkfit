import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SetUpScreen extends StatefulWidget {
  const SetUpScreen({super.key});

  @override
  State<SetUpScreen> createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/setup.png'),
              SizedBox(height: 10.h),
              Center(child: Text(tr("all_set"), style: AppTextStyles.headling)),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  tr("password_changed"),
                  style: AppTextStyles.subHeading(context),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: CustomButton(
            title: tr("sign_in"),
            onPressed: () {
              // Get.to(()=>LoginScreen());
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ),
      ),
    );
  }
}
