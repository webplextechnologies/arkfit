import 'dart:convert';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/account_set_up_screen.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/auth/model/signup_model.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecured = true.obs;
  var confirmPasswordController = TextEditingController();
  var isObsecured2 = true.obs;
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

  Future<void> signUp(context) async {
    var url = ApiUrls.register;
    var body = jsonEncode({
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "confirm_password": confirmPasswordController.text.trim()
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

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        print('jsonResponse : $jsonResponse');
        SignUpModel model = SignUpModel.fromJson(jsonResponse);
        AppSnackBar.showSuccess("Account created successfully");
        prefs.setString('token', model.token ?? '');
        prefs.setString('next_step', model.next!);
         if(model.next == "onboarding"){
         Get.to(() => AccountSetUpScreen());
        }
        else{
          Get.offAllNamed(AppRoutes.dashboard);
        }
       // Get.to(() => AccountSetUpScreen());
      } else {
        var errorResponse = jsonDecode(response.body);
        print('errorResponse : $errorResponse');
        final errors = errorResponse['messages'];

        emailError.value = errors['email'] ?? '';
        passwordError.value = errors['password'] ?? '';
        showSnackBar("Sign up failed", context);
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
