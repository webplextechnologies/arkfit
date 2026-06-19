import 'dart:convert';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/addMeals/model/meals_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealController extends GetxController {
  var isLoading = false.obs;
  var mealsList = <MealsList>[].obs;
  var selectedDate = DateTime.now();

  @override
  void onInit() {
    fetchMeals();
    super.onInit();
  }

  Future<void> fetchMeals() async {
    print("fetchFoodDetails");
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.meals);
      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.meals);
      if (response.statusCode == 200) {
        print(response.body);
        MealsListModel model = MealsListModel.fromJson(jsonResponse);
        mealsList.value = model.data!;
      }
    } catch (e) {
      AppSnackBar.showError("${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> createMeal(String mealType) async {
    var body = {
      "meal_type": mealType,
      "meal_date": apiDateFormat(selectedDate),
    };

    print(body);

    try {
      final response = await ApiServices.postRequest(ApiUrls.meals, body: body);

      final json = jsonDecode(response.body);

      if (json["status"] == true) {
        final int mealId = json["meal_id"];
        debugPrint("Meal created successfully with ID: $mealId");
        return mealId.toString();
      } else {
        debugPrint("Meal creation failed");
        return null;
      }
    } catch (e) {
      debugPrint("Add meal error: $e");
      return null;
    }
  }

  Future<bool> removeFood(foodId) async {
    try {
      final response = await ApiServices.deleteRequest(
        "${ApiUrls.addMealItem}$foodId",
      );
      print("${ApiUrls.addMealItem}$foodId");

      if (response.statusCode == 200) {
        print(response.body);
        fetchMeals();
        AppSnackBar.showSuccess("Food log successfully deleted!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("delete Food error: $e");
      return false;
    }
  }

  String apiDateFormat(DateTime date) {
    final DateTime finaldate = date;
    return "${finaldate.year.toString().padLeft(4, '0')}-"
        "${finaldate.month.toString().padLeft(2, '0')}-"
        "${finaldate.day.toString().padLeft(2, '0')}";
  }
}
