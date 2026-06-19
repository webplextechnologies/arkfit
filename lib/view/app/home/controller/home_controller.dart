import 'dart:convert';
import 'dart:developer';
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/home/model/dashboard_data_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var selectedDateText = "".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  var isLoading = false.obs;
  var calories = Calories().obs;
  var macros = Macros().obs;
  var steps = Steps().obs;
  var activity = Activities().obs;

  var breakfast = Breakfast().obs;
  var lunch = Lunch().obs;
  var dinner = Dinner().obs;
  var snacks = Snacks().obs;
  var micronutrients = Micronutrients().obs;
  var isPremiumUser = false.obs;
  late SharedPreferences prefs;

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    dashboardData(selectedDate.value);
    selectedDateText.value = formatDate(selectedDate.value);
    print(selectedDate.value);
    loadPremiumStatus();
    super.onInit();
  }

  void loadPremiumStatus() {
    final isPremium = prefs.getBool('isPremium') ?? false;
    isPremiumUser.value = isPremium;

    print("isPremium : $isPremium");
  }

  Future<void> dashboardData(date, {bool showLoader = true}) async {
    print("dashboardData");
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      if (showLoader) isLoading.value = true;

      final response = await ApiServices.getRequest(
        "${ApiUrls.dashboard}?date=$formattedDate",
      );

      final jsonResponse = jsonDecode(response.body);
      print("${ApiUrls.dashboard}?date=$formattedDate");

      if (response.statusCode == 200) {
        DashboardDataModel model = DashboardDataModel.fromJson(jsonResponse);
        calories.value = model.calories!;
        macros.value = model.macros!;
        steps.value = model.steps!;
        activity.value = model.activities!;
        breakfast.value = model.meals!.breakfast!;
        lunch.value = model.meals!.lunch!;
        dinner.value = model.meals!.dinner!;
        snacks.value = model.meals!.snacks!;
        micronutrients.value = model.micronutrients!;

        log(response.body);
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  List<String> months = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    selectedDateText.value = formatDate(selectedDate.value);
    dashboardData(selectedDate.value);
  }

  void nextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    selectedDateText.value = formatDate(selectedDate.value);
    dashboardData(selectedDate.value);
  }

  Future<void> selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,

              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: Colors.white,
              dayForegroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
              ),
              dayBackgroundColor: MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.selected)
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              todayForegroundColor: MaterialStateProperty.all(
                isDark ? Colors.white : AppColors.primary,
              ),
              todayBackgroundColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              todayBorder: BorderSide(color: AppColors.primary, width: 1.5),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: isDark ? Colors.grey.shade900 : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      selectedDateText.value = formatDate(picked);
      dashboardData(selectedDate.value);
    }
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();

    bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    bool isYesterday =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    if (isToday) {
      return "${tr("today")}, ${months[date.month]} ${date.day}";
    } else if (isYesterday) {
      return "${tr("yesterday")}, ${months[date.month]} ${date.day}";
    } else {
      return "${months[date.month]} ${date.day}, ${date.year}";
    }
  }
}
