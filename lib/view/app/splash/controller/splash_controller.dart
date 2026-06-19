import 'package:ark_fit_gym/view/app/account_setup/screens/account_set_up_screen.dart';
import 'package:ark_fit_gym/view/app/auth/welcome_screen.dart';
import 'package:ark_fit_gym/view/app/onboarding/onboarding_screen.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
class SplashController extends GetxController {
  @override
  void onInit() {
    navigateToNextScreen();
    super.onInit();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final nextStep = prefs.getString('next_step');
     final Step = prefs.getInt('onboarding_step');
    //onboarding_step
    print("$token");
    print("$Step");
    print("$nextStep");
    if (token != null && token.isNotEmpty) {
      if (nextStep == "onboarding") {
        Get.offAll(() => WelcomeScreen());
      } else {
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }
}
*/

class SplashController extends GetxController {
  @override
  void onInit() {
    navigateToNextScreen();
    super.onInit();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();

    final bool isFirstTime = prefs.getBool('is_first_time') ?? true;
    final String? token = prefs.getString('token');
    final String? nextStep = prefs.getString('next_step');
    final int? onboardingStep = prefs.getInt('onboarding_step');

    debugPrint("First time: $isFirstTime");
    debugPrint("Token: $token");
    debugPrint("Step: $onboardingStep");
    debugPrint("Next: $nextStep");

    if (isFirstTime) {
      await prefs.setBool('is_first_time', false);
      Get.offAll(() => OnboardingScreen());
      return;
    }
    
    if (token != null && token.isNotEmpty) {
      if (nextStep == "onboarding") {
        Get.offAll(() => WelcomeScreen());
      } else {
        Get.offAllNamed(AppRoutes.dashboard);
      }
      return;
    }
    Get.offAll(() => WelcomeScreen());
  }
}

