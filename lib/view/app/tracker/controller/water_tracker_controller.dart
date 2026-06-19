import 'dart:convert';

import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/tracker/model/today_water_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaterTrackerController extends GetxController {
  var isLoading = false.obs;
  var consumedWater = 0.obs;
  var targetWater = 0.obs;
  var remainingWater = 0.obs;
  // var  waterController = TextEditingController(text: "250").obs;
  // var  waterGoalController = TextEditingController;

  /*   @override
  void onInit() {
    todayWaterSummary();
    waterGoalController = TextEditingController(text: targetWater.value).obs;
    super.onInit();
  } */
  late TextEditingController waterController;
  late TextEditingController waterGoalController;

  @override
  void onInit() {
    super.onInit();

    waterController = TextEditingController(text: "250");
    waterGoalController = TextEditingController(
      text: targetWater.value.toString(),
    );

    todayWaterSummary();
  }

  double get waterLevel =>
      targetWater.value == 0 ? 0 : consumedWater.value / targetWater.value;

  Future<void> todayWaterSummary() async {
    print("todayWaterSummary");
    try {
      isLoading.value = true;

      final response = await ApiServices.getRequest(ApiUrls.todayWater);

      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.todayWater);

      if (response.statusCode == 200) {
        TodayWaterModel model = TodayWaterModel.fromJson(jsonResponse);
        consumedWater.value = model.consumedMl ?? 0;
        targetWater.value = model.targetMl ?? 0;
        remainingWater.value = model.remainingMl ?? 0;
         waterGoalController.text = targetWater.value.toString();

        print("waterLevel :${waterLevel}");

        print(response.body);
      }
    } catch (e) {
      print("Failed to fetch water: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addWater() async {
    print("addWater");
    var body = {"amount_ml": waterController.value.text.trim()};
    print(body);
    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        ApiUrls.addWater,
        body: body,
      );

      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.addWater);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        await todayWaterSummary();
      }
    } catch (e) {
      print("Failed to add water: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
