import 'dart:convert';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/auth/set_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CreatePasswordController extends GetxController {
  var isLoading = false.obs;
  var isObsecured = true.obs;
  var isConfirmObsecured = true.obs;
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  Future<void> resetPassword(context, email) async {
    if (passwordController.text.trim().isEmpty) {
      showSnackBar("Please enter Password", context);
      return;
    }
    var url = ApiUrls.resetPassword;

    var body = jsonEncode({
      "email": email,
      "password": passwordController.text.trim(),
    });
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
        Get.to(() => SetUpScreen());
        AppSnackBar.showSuccess("Password reset successfully");
      } else {
        var errorResponse = jsonDecode(response.body);
        final messages = errorResponse['messages'];
        showSnackBar(messages.values.first.toString(), context);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.w)),
      ),
    );
  }
}
