import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/auth/controller/forget_password_controller.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late ForgetPasswordController forgetPasswordController;

  @override
  void initState() {
    forgetPasswordController = Get.put(ForgetPasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${tr("forgot_password")} 🔑", style: AppTextStyles.headling),

                    SizedBox(height: 8.h),

                    Text(
                      tr("email_instruction"),
                      style: AppTextStyles.subHeading(context),
                    ),

                    SizedBox(height: 30.h),

                    CustomTextField(
                      onChanged: (value) {
                        forgetPasswordController.emailError.value = "";
                      },
                      controller: forgetPasswordController.emailController,
                      label: tr("registered_email"),
                      hintText: tr("enter_email"),
                      keyboardType: TextInputType.emailAddress,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/Message.svg",
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Icon(Icons.email_outlined),
                    ),
                    Obx(
                      () => forgetPasswordController.emailError.value.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(top: 6.w, left: 6.w),
                              child: Text(
                                forgetPasswordController.emailError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
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
                title: tr("send_otp"),
                onPressed: () {
                  forgetPasswordController.sendOtp(context);
                  //Get.to(() => OtpScreen());
                },
              ),
            ),
          ),
        ),

        Obx(
          () => forgetPasswordController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularLoader(),
                  ),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}
