import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/auth/controller/create_password_controller.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String email;
  const CreatePasswordScreen({super.key, required this.email});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late CreatePasswordController createPasswordController;

  @override
  void initState() {
    createPasswordController = Get.put(CreatePasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${tr("secure_account")} 🔒", style: AppTextStyles.headling),

                SizedBox(height: 8.h),

                Text(
                  tr("security_msg"),
                  style: AppTextStyles.subHeading(context),
                ),

                SizedBox(height: 30.h),

                Obx(
                  () => CustomTextField(
                    controller: createPasswordController.passwordController,
                    fillColor: Colors.grey.shade100,
                    label: tr("create_new_password"),
                    hintText: tr("enter_new_password"),
                    obscureText: createPasswordController.isObsecured.value,
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
                        createPasswordController.isObsecured.value =
                            !createPasswordController.isObsecured.value;
                      },
                      icon: Icon(
                        createPasswordController.isObsecured.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                /*
                 SizedBox(height: 20.h),
                CustomTextField(
                  fillColor: Colors.grey.shade100,
                  label: "Confirm new password",
                  hintText: "Confirm your new password",
                  obscureText: obscurePassword,
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
                        createPasswordController.isConfirmObsecured.value =
                            !createPasswordController.isConfirmObsecured.value;
                      },
                      icon: Icon(
                        createPasswordController.isConfirmObsecured.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
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
          child: CustomButton(
            title: tr("save_new_password"),
            onPressed: () {
              createPasswordController.resetPassword(context, widget.email);
            },
          ),
        ),
      ),
    );
  }
}
