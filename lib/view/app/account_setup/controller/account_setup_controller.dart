import 'dart:convert';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/activity_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/birthday_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/country_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/current_weight_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/diet_type_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/gender_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/height_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/main_goal_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/meal_time_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/name_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/pace_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/target_weight_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/model/account_setup_model.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/activity_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/birthday_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/meal_time_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/calorie_plan_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/country_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/current_weight_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/diet_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/gender_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/goal_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/height_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/name_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/pace_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/personalising_exp_screen.dart';
import 'package:ark_fit_gym/view/app/account_setup/screens/target_weight_screen.dart';
import 'package:ark_fit_gym/view/app/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSetUpController extends GetxController {
  var step = 0.obs;
  var currentStep = 1.obs;
  var isLoading = false.obs;
  var nutrition = NutritionModel().obs;
  
  VoidCallback? onSubmit;

  final List<String> onboardingBackgrounds = [
    'assets/images/firstLast_name.jpg',
    'assets/images/gender.png',
    'assets/images/birthday.png',
    'assets/images/height.png',
    'assets/images/current_weight.png',
    'assets/images/target_weight.jpg',
    'assets/images/main_goal.jpg',
    'assets/images/activity_level.jpg',
    'assets/images/diet_type.jpg',
    'assets/images/dinner.jpg',
    'assets/images/country_.png',
    'assets/images/pace_image.jpg',
    "assets/images/personalising_exp.png",
    "assets/images/calorie_plan.png",
  ];

  @override
  void onInit() {
    super.onInit();
    loadStep();
  }

  Future<void> loadStep() async {
    final prefs = await SharedPreferences.getInstance();
    currentStep.value = prefs.getInt('onboarding_step') ?? 1;
    step.value = currentStep.value - 1;
  }

  Future<void> getNutritionPlan() async {
    print(ApiUrls.getNutrition);
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.getNutrition);
      print(ApiUrls.getNutrition);
      isLoading.value = false;
      if (response.statusCode == 200) {
        print(response.body);
        final body = jsonDecode(response.body);
        AccountSetupDataModel model = AccountSetupDataModel.fromJson(body);
        nutrition.value = model.data!;
        update();
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> submitCurrentStep() async {
    final prefs = await SharedPreferences.getInstance();

    switch (currentStep.value) {
      case 1:
        Get.find<NameScreenController>().submit();
        break;

      case 2:
        Get.find<GenderController>().submit();
        break;

      case 3:
        Get.find<BirthdayController>().submit();
        break;

      case 4:
        Get.find<HeightController>().submit();
        break;

      case 5:
        Get.find<CurrentWeightController>().submit();
        break;

      case 6:
        Get.find<TargetWeightController>().submit();
        break;

      case 7:
        Get.find<MainGoalController>().submit();
        break;

      case 8:
        Get.find<ActivityController>().submit();
        break;

      case 9:
        Get.find<DietTypeController>().submit();
        break;

      case 10:
        Get.find<MealTimeController>().submit();
        break;

      case 11:
        Get.find<CountryController>().submit();
        break;
      case 12:
        Get.find<PaceController>().submit();
        break;
      case 13:
        debugPrint("⏳ Step 13 → Fetching nutrition plan");

        await getNutritionPlan();

        currentStep.value++;
        step.value = currentStep.value - 1;

        update();

        break;
      case 14:
        debugPrint("🏁 Step 14 reached — navigating to Dashboard");

        await prefs.remove('onboarding_step');
        await prefs.setString('next_step', 'dashboard');
        Get.offAll(() => DashboardScreen());
        break;

      default:
        debugPrint("⚠️ No handler for step ${currentStep.value}");
    }
  }

  Future<void> saveStepData({required Map<String, dynamic> data}) async {
    final prefs = await SharedPreferences.getInstance();

    if (currentStep.value == OnboardingSteps.personalising ||
        currentStep.value == OnboardingSteps.caloriePlan) {
      debugPrint("⏭ Skipping API for step ${currentStep.value}");

      if (currentStep.value == OnboardingSteps.caloriePlan) {
        await prefs.remove('onboarding_step');
        Get.offAll(() => DashboardScreen());
        return;
      }

      currentStep.value++;
      await prefs.setInt('onboarding_step', currentStep.value);
      step.value = currentStep.value - 1;
      update();
      return;
    }

    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        "${ApiUrls.onboardingSteps}${currentStep.value}",
        body: Map<String, dynamic>.from(data),
      );

      isLoading.value = false;

      debugPrint("📤 Step: ${currentStep.value}");
      debugPrint("📤 Data: $data");
      debugPrint("📥 Status: ${response.statusCode}");
      debugPrint("📥 Body: ${response.body}");

      if (response.statusCode == 200) {
        currentStep.value++;
        await prefs.setInt('onboarding_step', currentStep.value);
        step.value = currentStep.value - 1;
        update();
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          body['messages']?['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("❌ Error: $e");
      Get.snackbar("Error", "Unexpected error occurred");
    }
  }

  void back() {
    if (step.value > 0) {
      step.value--;
      currentStep.value = step.value + 1;
    }
  }

  void next() {
    if (step.value < onboardingBackgrounds.length - 1) {
      step.value++;
      currentStep.value = step.value + 1;
      print(step.value);
    } else {
      print("finish");
      Get.offAll(() => DashboardScreen());
    }
  }

  /// Screen mapper
  Widget currentSteps(int step) {
    switch (step) {
      case 0:
        return NameScreen();
      case 1:
        return GenderScreen();
      case 2:
        return BirthdayScreen();
      case 3:
        return HeightScreen();
      case 4:
        return CurrentWeightScreen();
      case 5:
        return TargetWeightScreen();
      case 6:
        return MainGoalScreen();
      case 7:
        return AcitivyLevelScreen();
      case 8:
        return DietTypeScreen();
      case 9:
        return MealTimeScreen();
      case 10:
        return CountryScreen();
      case 11:
        return PaceScreen();
      case 12:
        return PersonalisingExpScreen();
      case 13:
        return CaloriePlanScreen();
      default:
        return const SizedBox();
    }
  }
}

class OnboardingSteps {
  static const name = 1;
  static const gender = 2;
  static const birthday = 3;
  static const height = 4;
  static const currentWeight = 5;
  static const targetWeight = 6;
  static const mainGoal = 7;
  static const activity = 8;
  static const diet = 9;
  static const meal = 10;
  static const country = 11;
  static const pace = 12;
  static const personalising = 13;
  static const caloriePlan = 14;
}

/*class AccountSetUpController extends GetxController {
  var step = 0.obs;
  var isLoading = false.obs;
  var questions = <Questions>[].obs;

  final List<String> onboardingBackgrounds = [
    'assets/images/firstLast_name.png',
    'assets/images/gender.png',
    'assets/images/birthday.png',
    'assets/images/height.png',
    'assets/images/current_weight.png',
    'assets/images/target_weight.png',
    'assets/images/main_goal.jpg',
    'assets/images/activity_level.jpg',
    'assets/images/diet_type.jpg',
    //'assets/images/breakfast.png',
    'assets/images/dinner.jpg',
    'assets/images/country.png',
    "assets/images/personalising_exp.png",
    "assets/images/calorie_plan.png",
  ];

 

  var currentStep = 1.obs;

  @override
  void onInit() {
    loadStep();
    super.onInit();
  }

  Future<void> loadStep() async {
    final prefs = await SharedPreferences.getInstance();
    currentStep.value = prefs.getInt('onboarding_step') ?? 1;
  }

  Future<void> saveStepData({
    required int step,
    required Map<String, dynamic> data,
  }) async {
    final response = await ApiServices.postRequest(
       "${ApiUrls.onboardingSteps}$step",
      body: data,
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('onboarding_step', step + 1);

      currentStep.value = step + 1;
    }
  }

  
  void next() {
    if (step.value < onboardingBackgrounds.length - 1) {
      step.value++;
    } else {
      print("finish");
      Get.offAll(() => DashboardScreen());
    }
  }

  void back() {
    if (step.value > 0) step.value--;
  }

  Widget currentSteps(step) {
    switch (step) {
      case 0:
        return NameScreen();
      case 1:
        return GenderScreen();
      case 2:
        return BirthdayScreen();
      case 3:
        return HeightScreen();
      case 4:
        return CurrentWeightScreen();
      case 5:
        return TargetWeightScreen();
      case 6:
        return MainGoalScreen();
      case 7:
        return AcitivyLevelScreen();
      case 8:
        return DietTypeScreen();
      // case 9:
      //   return BreakfastTimeScreen();
      case 9:
        return MealTimeScreen();
      case 10:
        return CountryScreen();
      case 11:
        return PersonalisingExpScreen();
      case 12:
        return CaloriePlanScreen();
      default:
        return const SizedBox();
    }
  }
}*/
