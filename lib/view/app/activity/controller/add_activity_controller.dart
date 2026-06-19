import 'dart:async';
import 'dart:convert';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/activity/model/search_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddActivityController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  var searchActivity = <SearchActivity>[].obs;
  var selectedTab = 0.obs; // 0=Recent, 1=Favorites, 2=Personal

  Timer? _debounce;
  var isLoading = false.obs;

  final List<String> tabTitles = [
  "Recent",
  "Favorites",
  "Personal",
];

String get selectedTabTitle => tabTitles[selectedTab.value];

  @override
  void onInit() {
    fetchRecentActivity();
    super.onInit();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    searchController.clear();
    switch (index) {
      case 0:
        fetchRecentActivity();
        break;
      case 1:
        fetchFavoriteActivity();
        break;
      case 2:
        fetchCustomActivity();
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
        searchActivityApi(query.trim());
      }
    });
  }

  Future<void> searchActivityApi(String query) async {
    final url = "${ApiUrls.searchActivity}$query";
    print(url);
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(url);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SearchActivityModel model = SearchActivityModel.fromJson(jsonResponse);
        searchActivity.value = model.data ?? [];
        print("$jsonResponse");
      }
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- RECENT ----------------
  Future<void> fetchRecentActivity() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.recentActivity);
      print(ApiUrls.recentActivity);
      print(response.body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SearchActivityModel model = SearchActivityModel.fromJson(jsonResponse);
        searchActivity.value = model.data ?? [];
        print(response.body);
      }
      else{
        print(response.statusCode);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch recent food");
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- FAVORITES ----------------
  Future<void> fetchFavoriteActivity() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.favoriteActivity);
      print(ApiUrls.favoriteActivity);
      print(response.body);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SearchActivityModel model = SearchActivityModel.fromJson(jsonResponse);
        searchActivity.value = model.data ?? [];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch favorite food");
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- PERSONAL ----------------
  Future<void> fetchCustomActivity() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        ApiUrls.createCustomActivity,
      );

      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.createCustomActivity);
      
      if (response.statusCode == 200) {
        SearchActivityModel model = SearchActivityModel.fromJson(jsonResponse);
        searchActivity.value = model.data ?? [];
        print(response.body);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch custom activity");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToRecentActivity(String activityId) async {
    try {
      final response = await ApiServices.postRequest(
        '${ApiUrls.addRecentActivity}$activityId',
      );

      print( '${ApiUrls.addRecentActivity}$activityId');

      if (response.statusCode == 200) {
        debugPrint("Added to recent activity $activityId");
      }
    } catch (e) {
      debugPrint("Add recent error: $e");
    }
  }
    Future<bool> removeCustomActivity(String activityId) async {
    try {
      final response = await ApiServices.deleteRequest(
        '${ApiUrls.deleteCustomActivity}/$activityId',
      );
       print('${ApiUrls.deleteCustomActivity}/$activityId');
      if (response.statusCode == 200) {
        print(response.body);
        fetchCustomActivity();
        AppSnackBar.showSuccess("Removed from personal food!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Remove favorite error: $e");
      return false;
    }
  }
  Future<bool> removefavoriteActivity(String activityId) async {
    try {
      final response = await ApiServices.deleteRequest(
        '${ApiUrls.addFavoriteActivity}$activityId',
      );
       print('${ApiUrls.addFavoriteActivity}$activityId');
      if (response.statusCode == 200) {
        print(response.body);
        fetchFavoriteActivity();
        AppSnackBar.showSuccess("Removed from favorites!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Remove favorite error: $e");
      return false;
    }
  }
   Future<bool> removeRecentActivity(String activityId) async {
    try {
      final response = await ApiServices.deleteRequest(
        '${ApiUrls.recentActivity}/$activityId',
      );
       print('${ApiUrls.recentActivity}/$activityId');
       print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        AppSnackBar.showSuccess("Removed from Recent food!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Remove favorite error: $e");
      return false;
    }
  }
}
