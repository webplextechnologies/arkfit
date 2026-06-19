import 'dart:convert';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/tracker/model/weight_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeightHistoryController  extends GetxController {
  
  var weightHistoryList = <WeightHistory>[].obs;
 var isLoading = false.obs;
 var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    fetchWeightHistory();
    super.onInit();
  }

  Future<void> fetchWeightHistory() async {
    print("fetchWeightHistory");
    try {
      isLoading.value = true;
       String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);

    final response = await ApiServices.getRequest(
      "${ApiUrls.weightHistory}?date=$formattedDate",
    );
      
      final jsonResponse = jsonDecode(response.body);
      print("${ApiUrls.stepsHistory}?date=$formattedDate");

      if (response.statusCode == 200) {
        WeightHistoryModel model = WeightHistoryModel.fromJson(jsonResponse);
        weightHistoryList.value = model.data ?? [];
        print(response.body);

      }
    } catch (e) {
      print("Failed to fetch step history: ${e.toString()}");
    }
     finally {
      isLoading.value = false;
    }
  }

   Future<bool> deleteweight(stepsId) async {
    try {
      final response = await ApiServices.deleteRequest(
        "${ApiUrls.deleteweight}$stepsId",
      );
      print("${ApiUrls.deleteweight}$stepsId");

      if (response.statusCode == 200) {
        print(response.body);
        fetchWeightHistory();
        AppSnackBar.showSuccess("Weight successfully deleted!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("delete Weight error: $e");
      return false;
    }
  }


}
