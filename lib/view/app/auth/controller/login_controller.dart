import 'dart:convert';
import 'dart:io';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/account_set_up_screen.dart';
import 'package:ark_fit_gym/view/app/auth/model/login_model.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecured = true.obs;

  var emailError = ''.obs;
  var passwordError = ''.obs;
  late SharedPreferences prefs;

  @override
  void onReady() async {
    prefs = await SharedPreferences.getInstance();
    super.onReady();
  }

  bool isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  Future<void> signIn(context) async {
    var url = ApiUrls.login;
    var body = jsonEncode({
      "email": emailController.text.trim(),
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
        LoginModel model = LoginModel.fromJson(jsonResponse);
        AppSnackBar.showSuccess("Login successfully");
        prefs.setString('token', model.token ?? '');
        prefs.setInt('onboarding_step', model.step!);
        prefs.setString('next_step', model.next!);
        if (model.next == "onboarding") {
          Get.to(() => AccountSetUpScreen());
        } else {
          Get.offAllNamed(AppRoutes.dashboard);
        }
      } else {
        var errorResponse = jsonDecode(response.body);
        print('jsonResponse : $errorResponse');
        final errors = errorResponse['messages'];

        passwordError.value = errors['error'] ?? '';
        showSnackBar("Sign In failed", context);
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
}
