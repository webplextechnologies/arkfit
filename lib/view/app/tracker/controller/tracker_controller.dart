import 'dart:convert';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account/model/onboarding_data_model.dart';
import 'package:ark_fit_gym/view/app/tracker/model/current_bmi_model.dart';
import 'package:ark_fit_gym/view/app/tracker/model/current_weight_model.dart';
import 'package:ark_fit_gym/view/app/tracker/model/today_water_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackerController extends GetxController {
  var isLoading = false.obs;

  var consumedWater = 0.obs;
  var targetWater = 0.obs;
  var remainingWater = 0.obs;

  var onboardingData = OnboardingData().obs;
  var currentWeight = CurrentWeight().obs;
  var currentBmi = CurrentBmi().obs;
  var stepGoal = 0.obs;

  var steps = 0.obs;

  @override
  void onInit() {
    loadAllData();
    super.onInit();
  }

  Future<void> openBMIReference() async {
    final Uri webUrl = Uri.parse(ApiUrls.openBmiSource);

    if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  double get waterLevel =>
      targetWater.value == 0 ? 0 : consumedWater.value / targetWater.value;

  Future<void> addWater() async {
    print("addWater");
    var body = {"amount_ml": 250};
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

  bool isUpdating = false;

  Future<void> updateWaterIntake() async {
    if (isUpdating) return;

    isUpdating = true;
    var body = {"amount_ml": 250};
    print(body);

    try {
      final response = await ApiServices.postRequest(
        ApiUrls.addWater,
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        await todayWaterSummary();
      }
    } catch (e) {
      print(e);
    } finally {
      isUpdating = false;
    }
  }

  Future<void> loadAllData({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;

      await Future.wait([
        todayWaterSummary(showLoader: false),
        todayStepsSummary(showLoader: false),
        fetchOnboardingData(showLoader: false),
        getCurrentBmi(showLoader: false),
        getCurrentWeight(showLoader: false),
      ]);
    } catch (e) {
      print("Error loading all data: $e");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> todayWaterSummary({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;

      final response = await ApiServices.getRequest(ApiUrls.todayWater);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        TodayWaterModel model = TodayWaterModel.fromJson(jsonResponse);
        consumedWater.value = model.consumedMl ?? 0;
        targetWater.value = model.targetMl ?? 0;
        remainingWater.value = model.remainingMl ?? 0;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch water");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> todayStepsSummary({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;

      final response = await ApiServices.getRequest(ApiUrls.todaySteps);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        steps.value = jsonResponse["steps"] ?? 0;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch steps");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> fetchOnboardingData({bool showLoader = true}) async {
    print("fetchOnboardingData");
    try {
      if (showLoader) isLoading.value = true;

      final response = await ApiServices.getRequest(ApiUrls.getOnboardingData);
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        OnboardingDataModel model = OnboardingDataModel.fromJson(jsonResponse);
        onboardingData.value = model.data!;

        print(jsonResponse);
      }
    } catch (e) {
      print("Onboarding error: $e");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> getCurrentWeight({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.currentWeight);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CurrentWeightModel model = CurrentWeightModel.fromJson(jsonResponse);
        currentWeight.value = model.data!;
        print(jsonResponse);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch weight");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> getCurrentBmi({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.currentBmi);
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CurrentBmiModel model = CurrentBmiModel.fromJson(jsonResponse);
        currentBmi.value = model.data!;
        print(jsonResponse);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch bmi");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  Future<void> updateBmi(String height, String weight) async {
    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        ApiUrls.currentBmi,
        body: {"height_cm": height, "weight_kg": weight},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getCurrentBmi(showLoader: false);
        AppSnackBar.showSuccess("BMI updated successfully");
      }
    } catch (e) {
      print("Failed to update bmi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateWeight(String weight) async {
    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        ApiUrls.addWeight,
        body: {"weight_kg": weight},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await Future.wait([
          getCurrentWeight(showLoader: false),
          getCurrentBmi(showLoader: false),
        ]);
        AppSnackBar.showSuccess("Weight updated successfully");
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print("Failed to update weight: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
