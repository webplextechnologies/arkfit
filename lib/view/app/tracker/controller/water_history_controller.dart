import 'dart:convert';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/tracker/model/water_history_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WaterHistoryController extends GetxController {
  var waterHistoryList = <WaterHistory>[].obs;
 var isLoading = false.obs;
 var selectedDate = DateTime.now().obs;
  @override
  void onInit() {
    fetchWaterHistory();
    super.onInit();
  }

  Future<void> fetchWaterHistory() async {
    print("fetchWaterHistory");
    try {
      isLoading.value = true;
       String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);

    final response = await ApiServices.getRequest(
      "${ApiUrls.waterHistory}?date=$formattedDate",
    );
      
      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.waterHistory);

      if (response.statusCode == 200) {
        WaterHistoryModel model = WaterHistoryModel.fromJson(jsonResponse);
        waterHistoryList.value = model.data ?? [];
        print(response.body);

      }
    } catch (e) {
      print("Failed to fetch water history: ${e.toString()}");
    }
     finally {
      isLoading.value = false;
    }
  }

}