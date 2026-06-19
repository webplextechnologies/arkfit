import 'dart:convert';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account/model/current_plan_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentPlanController extends GetxController {
  var isLoading = false.obs;
  String userId = "";
  var currentPlanModel = CurrentPlanModel().obs;

  @override
  void onInit() {
    super.onInit();
    getUserId();
  }

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    print("User ID: $userId");
    fetchCurrentPlan();
  }

  Future<void> fetchCurrentPlan() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        '${ApiUrls.currentPlan}$userId',
      );
      print('${ApiUrls.currentPlan}$userId');
      final jsonResponse = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        currentPlanModel.value = CurrentPlanModel.fromJson(jsonResponse);
        print("current Plans: ${response.body}");
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print("Failed to fetch plan: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      print("current plan : $e");
      AppSnackBar.showSnackBar("Failed to fetch plans");
    }
  }
}
