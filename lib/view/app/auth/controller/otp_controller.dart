import 'dart:convert';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/auth/create_new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OtpController extends GetxController {
  var pinController = TextEditingController();
  var isLoading = false.obs;
  var pinError = "".obs;

  Future<void> verifyOtp(context, email) async {
     if (pinController.text.trim().isEmpty) {
      showSnackBar("Please enter OTP", context);
      return;
    }
    var url = ApiUrls.forgotPasswordVerifyOtp;
    int otp = int.parse(pinController.text);
    var body = jsonEncode({"email": email, "otp": otp});
    print(url);
    print(body);
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      isLoading.value = false;
      print(response.statusCode);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('jsonResponse : $jsonResponse');
        Get.to(() => CreatePasswordScreen(email: email,));
        AppSnackBar.showSuccess("OTP verified successfully");
      } else {
        var errorResponse = jsonDecode(response.body);
        final messages = errorResponse['messages'];
        pinError.value = messages.values.first.toString();
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
      showSnackBar("Something went wrong. Try again.", context);
    }
  }

  void showSnackBar(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
