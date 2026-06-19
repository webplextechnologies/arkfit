import 'dart:convert';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordController {
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var emailError = "".obs;

  Future<void> sendOtp(context) async {
    var url = ApiUrls.forgotPasswordSendOtp;
    var body = jsonEncode({"email": emailController.text.trim()});
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
        Get.to(() => OtpScreen(email: emailController.text.trim(),));
         AppSnackBar.showSuccess("OTP sent successfully");
      
      } else {
        var errorResponse = jsonDecode(response.body);
        final messages = errorResponse['messages'];
        emailError.value = messages.values.first.toString();
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
