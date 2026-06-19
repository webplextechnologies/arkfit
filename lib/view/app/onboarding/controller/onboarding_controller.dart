import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;
  PageController pageController = PageController();

  void onPageChanged(int index) {
    pageIndex.value = index;
  }

  void nextPage() {
    if (pageIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
        Get.offAllNamed(AppRoutes.welcome);
        print('Finish onboarding');
    }
  }

  void skip() {
    pageController.jumpToPage(2);
  }
}
