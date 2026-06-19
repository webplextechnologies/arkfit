import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/auth/controller/otp_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool obscurePassword = true;

  late OtpController otpController;

  @override
  void initState() {
    otpController = Get.put(OtpController());
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
                    Text("${tr("enter_otp")} 🔐", style: AppTextStyles.headling),

                    SizedBox(height: 8.h),

                    Text(
                      tr("otp_info"),
                      style: AppTextStyles.subHeading(context),
                    ),

                    SizedBox(height: 30.h),
                    Center(
                      child: Pinput(
                        controller: otpController.pinController,
                        onChanged: (value) {
                          otpController.pinController.text = value;
                          otpController.pinError.value = "";
                        },
                        keyboardType: TextInputType.number,
                        defaultPinTheme: PinTheme(
                          margin: EdgeInsets.all(5.w),
                          width: 60.w,
                          height: 60.w,
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.background,
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          margin: EdgeInsets.all(5.w),
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary),
                          ),
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    Obx(
                      () => otpController.pinError.value.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(top: 6.w, left: 6.w),
                              child: Text(
                                otpController.pinError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 30.h),

                /*     Center(
                      child: Text(
                        tr("resend_timer"),
                        style: AppTextStyles.subHeading(context),
                      ),
                    ),

                    SizedBox(height: 20.h), */
                    Center(
                      child: Text(
                        "${tr("resend")} ",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
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
                title: tr("verify"),
                onPressed: () {
                  //Get.to(()=>CreatePasswordScreen());
                  otpController.verifyOtp(context, widget.email);
                },
              ),
            ),
          ),
        ),

        Obx(
          () => otpController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularLoader()),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}
