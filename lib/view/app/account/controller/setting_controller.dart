import 'dart:convert';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account/model/setting_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  var isLoading = false.obs;
  var settingsData = SettingsData().obs;
  RxBool pushNotifications = false.obs;
  RxBool emailNotifications = false.obs;
  RxBool communityNotifications = false.obs;
  RxBool profileVisibility = true.obs;
  var calorieGoalController = TextEditingController();
  var waterGoalController = TextEditingController();
  var weightGoalController = TextEditingController();
  var stepGoalController = TextEditingController();

  @override
  void onInit() {
    fetchSettinsData();
    super.onInit();
  }

  String get visibilityValue => profileVisibility.value ? "public" : "private";

  Future<void> fetchSettinsData() async {
    print("fetchSettinsData");
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.settings);
      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.settings);
      if (response.statusCode == 200) {
        SettingsDataModel model = SettingsDataModel.fromJson(jsonResponse);
        settingsData.value = model.data!;
        pushNotifications.value = model.data!.pushNotifications == "1";
        emailNotifications.value = model.data!.emailNotifications == "1";
        communityNotifications.value =
            model.data!.communityNotifications == "1";
        profileVisibility.value = model.data!.profileVisibility == "public";
        calorieGoalController.text = model.data?.calorieGoal?.toString() ?? '';
        weightGoalController.text = model.data?.weightGoal?.toString() ?? '';
        waterGoalController.text = model.data?.waterGoal?.toString() ?? '';
        stepGoalController.text = model.data?.stepGoal?.toString() ?? '';

        print(response.body);
      }
    } catch (e) {
      print(e.toString());
      // AppSnackBar.showSnackBar("Failed to fetch setting");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSettings() async {
    try {
      isLoading.value = true;

      final body = {
        "height_unit": settingsData.value.heightUnit,
        "weight_unit": settingsData.value.weightUnit,
        "calorie_unit": settingsData.value.calorieUnit,
        "water_unit": settingsData.value.waterUnit,
        "calorie_goal": settingsData.value.calorieGoal,
        "weight_goal": settingsData.value.weightGoal,
        "water_goal": settingsData.value.waterGoal,
        "step_goal": settingsData.value.stepGoal,
        "profile_visibility": profileVisibility.value,
        "push_notifications": pushNotifications.value,
        "email_notifications": emailNotifications.value,
        "community_notifications": communityNotifications.value,
      };
      print(body);
      await ApiServices.putRequest(ApiUrls.settings, body: body);
    } catch (e) {
      print("Update settings error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Unit Updates
  void updateHeightUnit(String unit) {
    settingsData.update((val) {
      val?.heightUnit = unit;
    });

    updateSettings();
  }

  void updateWeightUnit(String unit) {
    settingsData.update((val) {
      val?.weightUnit = unit;
    });

    updateSettings();
  }

  void updateCalorieUnit(String unit) {
    settingsData.update((val) {
      val?.calorieUnit = unit;
    });

    updateSettings();
  }

  void updateWaterUnit(String unit) {
    settingsData.update((val) {
      val?.waterUnit = unit;
    });

    updateSettings();
  }

  /// Toggle Switches
  void toggleVisibility(bool value) {
    profileVisibility.value = value;
    updateSettings();
  }

  void togglePush(bool value) {
    pushNotifications.value = value;
    updateSettings();
  }

  void toggleEmail(bool value) {
    emailNotifications.value = value;
    updateSettings();
  }

  void toggleCommunity(bool value) {
    communityNotifications.value = value;
    updateSettings();
  }

  /// Save Goals
  /// Save Goals
  void saveCalorieGoal() {
    settingsData.update((val) {
      val?.calorieGoal = calorieGoalController.text;
    });

    updateSettings();
  }

  void saveWeightGoal() {
    settingsData.update((val) {
      val?.weightGoal = weightGoalController.text;
    });

    updateSettings();
  }

  void saveWaterGoal() {
    settingsData.update((val) {
      val?.waterGoal = waterGoalController.text;
    });

    updateSettings();
  }

  void saveStepGoal() {
    settingsData.update((val) {
      val?.stepGoal = stepGoalController.text;
    });

    updateSettings();
  }
}
