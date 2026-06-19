import 'dart:convert';

import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSecurityController extends GetxController{

  var isLoading = false.obs;
   late SharedPreferences prefs;

  @override
  void onReady() async {
    prefs = await SharedPreferences.getInstance();
    super.onReady();
  }

  Future<void> deactivateAccount(BuildContext context) async {
  try {
    isLoading.value = true;

    final response =
        await ApiServices.deleteRequest(ApiUrls.deactivateAccount);

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final bool status = data['status'] ?? false;
      final String message = data['message'] ?? 'No message from server';

      if (status) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('onboarding_step');

        Get.deleteAll();

        Get.offAllNamed(AppRoutes.login);

        AppSnackBar.showSuccess(message);
      } else {
        AppSnackBar.showSnackBar(message);
      }
    } else {
      AppSnackBar.showSnackBar("Something went wrong. Please try again.");
    }

    isLoading.value = false;
  } catch (e) {
    isLoading.value = false;
    print(e.toString());
    AppSnackBar.showSnackBar(e.toString());
  }
}
  void showDeactivateAccountBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) {
      return SafeArea(
        child: Container(
          padding:  EdgeInsets.fromLTRB(20.w, 12.w, 20.w, 24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border:  Border(
              top: BorderSide(color: Colors.white, width: 1.w),
            ),
            borderRadius:  BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Handle
              Container(
                width: 40.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

               SizedBox(height: 20.w),

              /// Title
              Text(
                tr("deactivate_account"),
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

               SizedBox(height: 16.w),
               Divider(thickness: 0.5.w),
               SizedBox(height: 24.w),

              /// Message
               Text(
                tr("confirm_deactivate"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

               SizedBox(height: 12.w),

               Text(
                tr("reactivate_info"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),

               SizedBox(height: 24.w),
               Divider(thickness: 0.5.w),
               SizedBox(height: 24.w),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52.w,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        child: Text(
                          tr("cancel"),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(width: 16.w),

                  Expanded(
                    child: SizedBox(
                      height: 52.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          deactivateAccount(context); 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "${tr("yes")}, ${tr("deactivate")}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


void showDeleteAccountBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) {
      return SafeArea(
        child: Container(
          padding:  EdgeInsets.fromLTRB(20.w, 12.w, 20.w, 24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border:  Border(
              top: BorderSide(color: Colors.white, width: 1.w),
            ),
            borderRadius:  BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Handle
              Container(
                width: 40.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

               SizedBox(height: 20.w),

              /// Title
              Text(
                tr("delete_account"),
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

               SizedBox(height: 16.w),
               Divider(thickness: 0.5.w),
               SizedBox(height: 24.w),

              /// Message
               Text(
                tr("confirm_delete_account"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

               SizedBox(height: 12.w),

               Text(
                tr("delete_account_info"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),

               SizedBox(height: 24.w),
               Divider(thickness: 0.5.w),
               SizedBox(height: 24.w),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52.w,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        child: Text(
                          tr("cancel"),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(width: 16.w),

                  Expanded(
                    child: SizedBox(
                      height: 52.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          deactivateAccount(context); 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "${tr("yes")}, ${tr("delete")}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
}