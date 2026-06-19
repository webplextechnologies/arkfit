import 'package:get/get.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';

class CurrentWeightController extends GetxController {
  /// UI unit only
  Rx<WeightUnit> selectedWeightUnit = WeightUnit.kg.obs;

  /// Stored weight (ALWAYS in KG)
  RxDouble weightKg = 60.0.obs;

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
   // accountController.onSubmit = submit;
  }

  /// Update from ruler (value always comes in KG)
  void updateWeight(double valueKg) {
    weightKg.value = valueKg;
  }

  /// Value for API
 // int get weightForApi => weightKg.value.round();
  double get weightForApi => weightKg.value;

  /// Text shown in UI
  String get weightText {
    if (selectedWeightUnit.value == WeightUnit.kg) {
      return weightKg.value.toStringAsFixed(1);
    } else {
      final pounds = weightKg.value * 2.20462;
      return pounds.toStringAsFixed(1);
    }
  }

  /// Submit to onboarding API
  void submit() {
    accountController.saveStepData(
      data: {
        "weight_kg": weightForApi,
      },
    );
  }
}


// class CurrentWeightController extends GetxController {
//   Rx<WeightUnit> selectedWeightUnit = WeightUnit.kg.obs;

  
// }
