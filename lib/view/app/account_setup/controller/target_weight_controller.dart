import 'package:get/get.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
/*
class TargetWeightController extends GetxController {
  Rx<WeightUnit> selectedWeightUnit = WeightUnit.kg.obs;
}*/

import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';

class TargetWeightController extends GetxController {
  Rx<WeightUnit> selectedWeightUnit = WeightUnit.kg.obs;

  /// store base value in KG
  RxDouble targetWeightKg = 60.0.obs;

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
    accountController.onSubmit = submit;
  }

  void updateWeight(double value) {
    if (selectedWeightUnit.value == WeightUnit.kg) {
      targetWeightKg.value = value;
    } else {
      targetWeightKg.value = value / 2.20462;
    }
  }

  void submit() {
    accountController.saveStepData(
      data: {
        "target_weight_kg": targetWeightKg.value.round(),
      },
    );
  }
}

