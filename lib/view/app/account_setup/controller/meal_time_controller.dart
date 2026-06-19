import 'package:get/get.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:flutter/material.dart';

class MealTimeController extends GetxController {
  late AccountSetUpController accountController;

  Rx<TimeOfDay?> breakfast = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> lunch = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> snack = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> dinner = Rx<TimeOfDay?>(null);

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
   // accountController.onSubmit = submit;
  }

  /// Convert TimeOfDay → HH:mm
  String _format(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  /*void submit() {
    if (breakfast.value == null ||
        lunch.value == null ||
        snack.value == null ||
        dinner.value == null) {
      Get.snackbar("Error", "Please select all meal times");
      return;
    }

    accountController.saveStepData(
      data: {
        "breakfast_time": _format(breakfast.value!),
        "lunch_time": _format(lunch.value!),
        "snack_time": _format(snack.value!),
        "dinner_time": _format(dinner.value!),
      },
    );
  }*/
  void submit() {
  if (breakfast.value == null &&
      lunch.value == null &&
      snack.value == null &&
      dinner.value == null) {

    accountController.saveStepData(data: {});
    return;
  }

  Map<String, dynamic> data = {
    if (breakfast.value != null) "breakfast_time": _format(breakfast.value!),
    if (lunch.value != null) "lunch_time": _format(lunch.value!),
    if (snack.value != null) "snack_time": _format(snack.value!),
    if (dinner.value != null) "dinner_time": _format(dinner.value!),
  };

  accountController.saveStepData(data: data);
}
}
/*
class MealTimeController extends GetxController {

  late AccountSetUpController accountController;

  Rx<TimeOfDay?> breakfast = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> lunch = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> snack = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> dinner = Rx<TimeOfDay?>(null);

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
  }

  /// Convert TimeOfDay → HH:mm
  String _format(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  void submit() {

    Map<String, dynamic> data = {};

    if (breakfast.value != null) {
      data["breakfast_time"] = _format(breakfast.value!);
    }

    if (lunch.value != null) {
      data["lunch_time"] = _format(lunch.value!);
    }

    if (snack.value != null) {
      data["snack_time"] = _format(snack.value!);
    }

    if (dinner.value != null) {
      data["dinner_time"] = _format(dinner.value!);
    }

    /// If nothing selected → still continue
    accountController.saveStepData(data: data);
  }
}
*/