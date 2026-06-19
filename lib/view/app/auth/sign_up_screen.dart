import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/account_set_up_screen.dart';
import 'package:ark_fit_gym/view/app/auth/controller/signup_controller.dart';
import 'package:ark_fit_gym/view/app/auth/login_screen.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isChecked = false;
  bool obscurePassword = true;

  late SignupController signupController;

  @override
  void initState() {
    signupController = Get.put(SignupController());
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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${tr("join_arkfit")} ✨", style: AppTextStyles.headling),
                    SizedBox(height: 8.w),
                    Text(
                      tr("create_account"),
                      style: AppTextStyles.subHeading(context),
                    ),
                    //SizedBox(height: 30.w),
                    SizedBox(height: 50.w),

                    /// EMAIL
                    CustomTextField(
                      onChanged: (value) {
                        signupController.emailError.value = '';
                      },
                      controller: signupController.emailController,
                      label: tr("email"),
                      hintText: tr("enter_email"),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: _svgIcon("assets/icons/Message.svg"),
                      fillColor: Colors.grey.shade100,
                    ),
                    Obx(
                      () => signupController.emailError.value.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(top: 6.w, left: 6.w),
                              child: Text(
                                signupController.emailError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                    ),

                    SizedBox(height: 20.w),

                    /// PASSWORD
                    Obx(
                      () => CustomTextField(
                        onChanged: (value) {
                          signupController.passwordError.value = '';
                        },

                        controller: signupController.passwordController,
                        label: tr("password"),
                        hintText: tr("enter_password"),
                        obscureText: signupController.isObsecured.value,
                        prefixIcon: _svgIcon("assets/icons/Lock.svg"),
                        suffixIcon: IconButton(
                          onPressed: () {
                            signupController.isObsecured.value =
                                !signupController.isObsecured.value;
                          },
                          icon: Icon(
                            signupController.isObsecured.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey[600],
                          ),
                        ),
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    Obx(
                      () => signupController.passwordError.value.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(top: 6.w, left: 6.w),
                              child: Text(
                                signupController.passwordError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                    ),
                      SizedBox(height: 20.w),

                    /// PASSWORD
                    Obx(
                      () => CustomTextField(
                        onChanged: (value) {
                          signupController.passwordError.value = '';
                        },

                        controller: signupController.confirmPasswordController,
                        label: tr("confirm_password"),
                        //tr("password"),
                        hintText: tr("confirm_your_password"),
                        obscureText: signupController.isObsecured2.value,
                        prefixIcon: _svgIcon("assets/icons/Lock.svg"),
                        suffixIcon: IconButton(
                          onPressed: () {
                            signupController.isObsecured2.value =
                                !signupController.isObsecured2.value;
                          },
                          icon: Icon(
                            signupController.isObsecured2.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey[600],
                          ),
                        ),
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                 

                    SizedBox(height: 20.w),

                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => isChecked = val!),
                        ),
                        Text(
                          "${tr("agree")}  ",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            // color: AppColors.textPrimary,
                          ),
                        ),
                        // Spacer(),
                        Text(
                          tr("terms_conditions"),
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.w),
                    // LOGIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${tr("already_have_account")} ",
                          //style: AppTextStyles.subheadling,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => LoginScreen()),
                          child: Text(
                            tr("sign_in"),
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /* SizedBox(height: 30.h),
                        
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 0.5.w)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            "or continue with",
                            //style: AppTextStyles.subheadling,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              // color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 0.5.w)),
                      ],
                    ),
                        
                    SizedBox(height: 30.h),
                        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialButton("assets/icons/google.png"),
                        _socialButton("assets/icons/apple.png"),
                        _socialButton("assets/icons/facebook.png"),
                        _socialButton("assets/icons/x.png"),
                      ],
                    ),*/
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
              child: /* CustomButton(
                title: "Sign up",
                onPressed: () {
                  signupController.signUp(context);
                  //Get.to(() => AccountSetUpScreen());
                },
              ), */ CustomButton(
                title:tr("sign_up"),
                 onPressed: isChecked
                    ? () => signupController.signUp(context)
                    : null, // disables button
                
              ),
            ),
          ),
        ),
        Obx(
          () => signupController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularLoader()),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  Widget _svgIcon(String asset) {
    return SizedBox(
      width: 40.w,
      height: 40.w,
      child: Center(
        child: SvgPicture.asset(asset, width: 20.w, height: 20.w),
      ),
    );
  }

  Widget _socialButton(String asset) {
    return Container(
      height: 48.w,
      width: 70.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(padding: EdgeInsets.all(10.w), child: Image.asset(asset)),
    );
  }
}
