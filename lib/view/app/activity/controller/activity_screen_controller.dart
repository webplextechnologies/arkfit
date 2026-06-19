import 'dart:convert';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/activity/model/activity_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityScreenController extends GetxController {
  var isLoading = false.obs;
  var selectedDate = DateTime.now();
  var activityList = <ActivityList>[].obs;
  var totalCalorie = 0.obs;

  @override
  void onInit() {
    fetchActivities();
    super.onInit();
  }

  Future<void> fetchActivities() async {
    print("fetchActivities");
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        "${ApiUrls.getActivityByDate}${apiDateFormat(selectedDate)}",
      );

      final jsonResponse = jsonDecode(response.body);
      print("${ApiUrls.getActivityByDate}${apiDateFormat(selectedDate)}");
      if (response.statusCode == 200) {
        print(response.body);
        ActivityListModel model = ActivityListModel.fromJson(jsonResponse);
        activityList.value = model.data!;
        totalCalorie.value = model.totalCalories??0;
      }else{
         print(response.body);
         print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
      AppSnackBar.showError("${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteActivity(activityId) async {
    try {
      final response = await ApiServices.deleteRequest(
        "${ApiUrls.deleteActivity}$activityId",
      );
      print("${ApiUrls.deleteActivity}$activityId");

      if (response.statusCode == 200) {
        print(response.body);
        activityList.refresh();
        fetchActivities();
        AppSnackBar.showSuccess("Activity successfully deleted!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("delete activity error: $e");
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
