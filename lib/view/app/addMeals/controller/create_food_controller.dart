import 'dart:convert';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateFoodController extends GetxController {
  var isLoading = false.obs;
  var nameController = TextEditingController();
  var caloriesController = TextEditingController();
  var proteinController = TextEditingController();
  var carbsController = TextEditingController();
  var fatsController = TextEditingController();
  var servingUnitController = TextEditingController();
  var unitController = TextEditingController();


Future<bool> createFood() async {

  if (nameController.text.trim().isEmpty ||
      caloriesController.text.trim().isEmpty ||
      proteinController.text.trim().isEmpty ||
      carbsController.text.trim().isEmpty ||
      fatsController.text.trim().isEmpty ||
      servingUnitController.text.trim().isEmpty ||
      unitController.text.trim().isEmpty) {
        
    AppSnackBar.showSnackBar("All fields are required");
    return false;
  }

  var body = {
    "name": nameController.text,
    "calories": caloriesController.text,
    "protein": proteinController.text,
    "carbs": carbsController.text,
    "fats": fatsController.text,
    "serving_unit": "${servingUnitController.text} ${unitController.text}",
  };
  print(body);

  try {
    isLoading.value = true;

    final response = await ApiServices.postRequest(
      ApiUrls.createFood,
      body: body,
    );

    final json = jsonDecode(response.body);
    print(json);

    if (response.statusCode == 200 || response.statusCode == 201) {

      AppSnackBar.showSuccess("Food created successfully");
      debugPrint("Food created successfully");

      Get.back();
      return true;

    } else {
      AppSnackBar.showSnackBar("Failed to create food");
      return false;
    }

  } catch (e) {
    debugPrint("Create food error: $e");
    return false;

  } finally {
    isLoading.value = false;
  }
}
}