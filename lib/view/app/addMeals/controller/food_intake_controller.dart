import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/addMeals/model/search_food_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodIntakeController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  var foodList = <FoodList>[].obs;
  var selectedTab = 0.obs; // 0=Recent, 1=Favorites, 2=Personal

  Timer? _debounce;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchRecentFood();
    super.onInit();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    searchController.clear();

    switch (index) {
      case 0:
        fetchRecentFood();
        break;
      case 1:
        fetchFavoriteFood();
        break;
      case 2:
        fetchPersonalFood();
        break;
    }
  }

  /// ---------------- SEARCH ----------------
  void onSearchChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.trim().isEmpty) {
        // restore current tab data
        changeTab(selectedTab.value);
      } else {
        searchFoodApi(query.trim());
      }
    });
  }

  Future<void> searchFoodApi(String query) async {
    final url = "${ApiUrls.searchFood}$query";
    print(url);
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(url);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SearchFoodModel model = SearchFoodModel.fromJson(jsonResponse);
        foodList.value = model.data ?? [];
      }
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- RECENT ----------------
  Future<void> fetchRecentFood() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.recentFood);
      print("${ApiUrls.recentFood}");
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SearchFoodModel model = SearchFoodModel.fromJson(jsonResponse);
        foodList.value = model.data ?? [];
        log(response.body);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch recent food");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- FAVORITES ----------------
  Future<void> fetchFavoriteFood() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.favoriteFood);
      print("${ApiUrls.favoriteFood}");
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SearchFoodModel model = SearchFoodModel.fromJson(jsonResponse);
        foodList.value = model.data ?? [];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch favorite food");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- PERSONAL ----------------
  Future<void> fetchPersonalFood() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.customFood);

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SearchFoodModel model = SearchFoodModel.fromJson(jsonResponse);
        foodList.value = model.data ?? [];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch personal food");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToRecentFood(String foodId) async {
    try {
      final response = await ApiServices.postRequest(
        '${ApiUrls.addRecentFood}$foodId',
      );
      print("${ApiUrls.addRecentFood}$foodId");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Added to recent food");
      }
    } catch (e) {
      debugPrint("Add recent error: $e");
    }
  }
}
