import 'dart:convert';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/tracker/model/step_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StepHistoryController  extends GetxController {
  
  var stepHistoryList = <StepHistoryList>[].obs;
 var isLoading = false.obs;
 var selectedDate = DateTime.now().obs;
  @override
  void onInit() {
    fetchStepHistory();
    super.onInit();
  }

  Future<void> fetchStepHistory() async {
    print("fetchStepHistory");
    try {
      isLoading.value = true;
       String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);

    final response = await ApiServices.getRequest(
      "${ApiUrls.stepsHistory}?date=$formattedDate",
    );
      
      final jsonResponse = jsonDecode(response.body);
      print("${ApiUrls.stepsHistory}?date=$formattedDate");

      if (response.statusCode == 200) {
        StepHistoryModel model = StepHistoryModel.fromJson(jsonResponse);
        stepHistoryList.value = model.data ?? [];
        print(response.body);

      }
    } catch (e) {
      print("Failed to fetch step history: ${e.toString()}");
    }
     finally {
      isLoading.value = false;
    }
  }

   Future<bool> removeSteps(stepsId) async {
    try {
      final response = await ApiServices.deleteRequest(
        "${ApiUrls.deleteSteps}$stepsId",
      );
      print("${ApiUrls.deleteSteps}$stepsId");

      if (response.statusCode == 200) {
        print(response.body);
        fetchStepHistory();
        AppSnackBar.showSuccess("Steps successfully deleted!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("delete step error: $e");
      return false;
    }
  }


}
