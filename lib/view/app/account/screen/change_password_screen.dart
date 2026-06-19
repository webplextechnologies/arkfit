import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/controller/change_password_controller.dart';
import 'package:ark_fit_gym/view/app/auth/controller/create_password_controller.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ChangePasswordController changePasswordController;

  @override
  void initState() {
    changePasswordController = Get.put(ChangePasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          tr("change_password"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  SizedBox(height: 20.w),
                Obx(
                  ()=> CustomTextField(
                    controller: changePasswordController.currentPasswordController,
                    fillColor: Colors.grey.shade100,
                    label: tr("current_password"),
                    hintText: tr("enter_current_password"),
                    obscureText: changePasswordController.isCurrentObsecured.value,
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
                          changePasswordController.isCurrentObsecured.value =
                              !changePasswordController.isCurrentObsecured.value;
                        },
                        icon: Icon(
                          changePasswordController.isCurrentObsecured.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[600],
                        ),
                      ),
                  ),
                ),
              
              SizedBox(
                height: 30.w,
              ),


                Obx(
                  ()=> CustomTextField(
                    controller: changePasswordController.newPasswordController,
                    fillColor: Colors.grey.shade100,
                    label: tr("create_new_password"),
                    hintText: tr("enter_new_password"),
                    obscureText: changePasswordController.isNewObsecured.value,
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
                        changePasswordController.isNewObsecured.value =
                            !changePasswordController.isNewObsecured.value;
                      },
                      icon: Icon(
                        changePasswordController.isNewObsecured.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
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
            title: tr("save_new_password"),
            onPressed: () {
            // createPasswordController.resetPassword(context, widget.email);
            },
          ),
        ),
      ),
    );
  }
}
