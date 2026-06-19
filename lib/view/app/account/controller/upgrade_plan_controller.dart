import 'dart:convert';
import 'dart:developer';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account/controller/current_plan_controller.dart';
import 'package:ark_fit_gym/view/app/account/model/subscription_plans_model.dart';
import 'package:ark_fit_gym/view/app/account/screen/confirm_subscription.dart';
import 'package:ark_fit_gym/view/app/account/screen/payment_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpgradePlanController extends GetxController {
  var subscriptionPlans = <SubscriptionPlans>[].obs;
  var isLoading = false.obs;
  String userId = "";

  @override
  void onInit() {
    fetchSubscriptionPlans();
    super.onInit();
    getUserId();
  }

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    print("User ID: $userId");
  }

  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.subscriptionPlans);
      final jsonResponse = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        SubscriptionPlansModel model = SubscriptionPlansModel.fromJson(
          jsonResponse,
        );
        subscriptionPlans.value = model.data ?? [];
        print("Subscription Plans: ${response.body}");
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print("Failed to fetch subscription plans: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      print("fetchSubscriptionPlans : $e");
      AppSnackBar.showSnackBar("Failed to fetch subscription plans");
    }
  }

  Future<void> createPayment(planId, String amount) async {
  var body = {
    "user_id": userId,
    "plan_id": planId,
    "amount": amount,
    "currency": 840,
  };

  print(body);

  try {
    isLoading.value = true;

    final response = await ApiServices.postRequest(
      ApiUrls.createPayment,
      body: body,
    );

    final json = jsonDecode(response.body);
    log(response.body);

    if (json["status"] == true) {
      String html = json["html"];

      final result = await Get.to(() => PaymentWebView(html));

      // ✅ Payment Success
      if (result == true) {
        //final currentPlanController = Get.find<CurrentPlanController>();

        // 🔥 IMPORTANT: Refresh latest plan
       // await currentPlanController.fetchCurrentPlan();

        // ✅ Save premium flag
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('isPremium');

        // ✅ Navigate (remove previous screens)
        Get.offAll(() => const ConfirmSubscription());
      } else {
        AppSnackBar.showSnackBar("Payment Failed ❌");
      }
    } else {
      AppSnackBar.showSnackBar(json["message"] ?? "Payment failed");
    }
  } catch (e) {
    debugPrint("Create payment error: $e");
  } finally {
    isLoading.value = false;
  }
}

  /* Future<void> createPayment(planId, String amount) async {
    var body = {
      "user_id": userId,
      "plan_id": planId,
      "amount": amount,
      "currency": 840,
    };
    print(body);
    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        ApiUrls.createPayment,
        body: body,
      );

      final json = jsonDecode(response.body);
      log(response.body);
      print(response.statusCode);
      if (json["status"] == true) {
        String html = json["html"];

        final result = await Get.to(() => PaymentWebView(html));
        print(result);
        if (result == true) {
          //AppSnackBar.showSuccess("Payment Successful");
          Get.to(ConfirmSubscription());
          
        } else {
          AppSnackBar.showSnackBar("Payment Failed ❌");
        }
      } else {
        AppSnackBar.showSnackBar(json["message"] ?? "Payment failed");
      }
    } catch (e) {
      debugPrint("Create payment error: $e");
    } finally {
      isLoading.value = false;
    }
  } */
}
