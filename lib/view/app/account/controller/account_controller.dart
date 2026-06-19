import 'dart:convert';
import 'dart:io';
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account/model/profile_model.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class AccountController extends GetxController {
  var isLoading = false.obs;
  var profile = Profile().obs;

  late SharedPreferences prefs;
  static const String savedTokenKey = "saved_fcm_token";

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();

    fetchProfile();
  }

  Future<void> openPlayStore() async {
  const packageName = "com.webopedian.arkfit";

  final Uri marketUrl = Uri.parse("market://details?id=$packageName");
  final Uri webUrl = Uri.parse(
    "https://play.google.com/store/apps/details?id=$packageName",
  );
  //https://play.google.com/store/apps/details?id=com.webopedian.arkfit

  if (await canLaunchUrl(marketUrl)) {
    await launchUrl(marketUrl);
  } else {
    await launchUrl(webUrl, mode: LaunchMode.externalApplication);
  }
}

  Future<void> fetchProfile({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;

      final response = await ApiServices.getRequest(ApiUrls.getProfile);
      final jsonResponse = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        ProfileModel model = ProfileModel.fromJson(jsonResponse);
        profile.value = model.data!;
        await sendDeviceToken(model.data!.id!);

        prefs.setString('userId', model.data!.id!);
        prefs.setBool('isPremium', model.data!.isPremium == "1");
      }
    } catch (e) {
      print("fetchProfile : $e");
      Get.snackbar("Error", "Failed to fetch profile");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> sendDeviceToken(String userId) async {
    try {
      String? newToken = await FirebaseMessaging.instance.getToken();
      String? oldToken = prefs.getString(savedTokenKey);

      if (newToken == null || newToken == oldToken) {
        print("Token already up-to-date");
        return;
      }

      var body = {
        "user_id": userId,
        "device_token": newToken,
        "device_type": Platform.isAndroid ? "android" : "ios",
      };

      var response = await ApiServices.postRequest(
        ApiUrls.getDeviceToken,
        body: body,
      );

      print(response.body);

      if (response.statusCode == 200) {
        /// ✅ Save latest token
        prefs.setString(savedTokenKey, newToken);
      }
    } catch (e) {
      print("sendDeviceToken error: $e");
    }
  }

  /// ✅ Logout
  Future<void> logOut(BuildContext context) async {
    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(ApiUrls.logout);
      final data = jsonDecode(response.body);

      final String message = data['message'] ?? 'Logged out';

      await prefs.remove('token');
      await prefs.remove('onboarding_step');
      await prefs.remove('isPremium');

      Get.deleteAll();

      Get.offAllNamed(AppRoutes.welcome);

      AppSnackBar.showSuccess(message);
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      isLoading.value = false; 
    }
  }

  /// Snackbar
  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'urbanist',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Logout Bottom Sheet (no change needed)
  void showLogOutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border(top: BorderSide(color: Colors.white, width: 1)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  tr("logout"),
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(thickness: 0.5),
                const SizedBox(height: 24),

                Text(
                  tr("logout_confirm"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 12),
                const Divider(thickness: 0.5),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            logOut(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff34C759),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "${tr("yes")}, ${tr("logout")}",
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
