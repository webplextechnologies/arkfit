import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/auth/controller/login_controller.dart';
import 'package:ark_fit_gym/view/app/auth/forget_password_screen.dart';
import 'package:ark_fit_gym/view/app/auth/sign_up_screen.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = true;
  bool obscurePassword = true;
  late LoginController loginController;

  @override
  void initState() {
    loginController = Get.put(LoginController());
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
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 17.w,),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                     //SizedBox(height: 10.h),
                     Text( 
                      "${tr("welcome_back")}! 👋",
                      style: AppTextStyles.headling,
                    ),
                        
                     SizedBox(height: 8.w),
                        
                     Text(
                      tr("sign_in_continue"),
                      style:  AppTextStyles.subHeading(context)
                    ),
                       // SizedBox(height: 30.w),
                     SizedBox(height: 50.w),
                        
                    CustomTextField(
                      onChanged: (value) {
                        loginController.passwordError.value = '';
                      },
                      controller: loginController.emailController,
                      label: tr("email"),
                      hintText: tr("enter_email"),
                      keyboardType: TextInputType.emailAddress,
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
                      fillColor: Colors.grey.shade100,
                    ),
                    Obx(
                      () => loginController.emailError.value.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding:  EdgeInsets.only(top: 6.w, left: 6.w),
                              child: Text(
                                loginController.emailError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                    ),
                        
                     SizedBox(height: 20.w),
                        
                    Obx(
                      () => CustomTextField(
                        onChanged: (value) {
                          loginController.passwordError.value = '';
                        },
                        controller: loginController.passwordController,
                        label:tr("password"),
                        hintText: tr("enter_password"),
                        obscureText: loginController.isObsecured.value,
                        prefixIcon: SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/Lock.svg",
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        
                        suffixIcon: IconButton(
                          onPressed: () {
                            loginController.isObsecured.value =
                                !loginController.isObsecured.value;
                          },
                          icon: Icon(
                            loginController.isObsecured.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey[600],
                          ),
                        ),
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    Obx(
                      () => loginController.passwordError.value.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding:  EdgeInsets.only(top: 6.w, left: 6.w),
                              child: Text(
                                loginController.passwordError.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                    ),
                     SizedBox(height: 20.w),
                        
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                        
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setState(() {
                              isChecked = val!;
                            });
                          },
                        ),
                         Text(
                          "${tr("remember_me")} ",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            //color: AppColors.textPrimary,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ForgetPasswordScreen());
                          },
                          child:  Text(
                            tr("forgot_password"),
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                        
                     SizedBox(height: 15.w),
                        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${tr("no_account")} ",
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                            //  color: AppColors.primary,
                            ),
                           // AppTextStyles.subheadling,
                        ),
                        GestureDetector(
                          onTap: () async{
                            await Get.to(() => SignUpScreen());
                            loginController.passwordError.value = '';
                          } ,
                          child: Text(
                            tr("sign_up"),
                           // "Sign up",
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                        
                    /*SizedBox(height: 30.w),
                        
                    Row(
                      children:  [
                        Expanded(child: Divider(thickness: 0.5.w)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "or continue with",
                            //style: AppTextStyles.subheadling,
                             style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                            //  color: AppColors.primary,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 0.5.w)),
                      ],
                    ),
                        
                     SizedBox(height: 30.w),
                        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialButton("assets/icons/google.png"),
                        //_socialButton("assets/icons/apple.png"),
                        _socialButton("assets/icons/facebook.png"),
                       // _socialButton("assets/icons/x.png"),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        
          bottomNavigationBar: SafeArea(
            child: Container(
              padding:  EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
        
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: CustomButton(
                title:  tr("sign_in"),
                onPressed: () {
                  loginController.signIn(context);
                  // Get.to(() => AccountSetUpScreen());
                    
                },
              ),
            ),
          ),
        ),
        Obx(
          () => loginController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularLoader(),
                    // CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              : SizedBox(),
        ),
      ],
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
      child: Padding(
        padding:  EdgeInsets.all(10.w),
        child: Image.asset(asset),
      ),
    );
  }
}
