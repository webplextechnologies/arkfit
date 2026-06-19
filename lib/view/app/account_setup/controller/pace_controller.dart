import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:get/get.dart';

class PaceController extends GetxController {

  //RxDouble paceValue = 1.0.obs; // range 1 → 10
    RxDouble paceValue = 0.5.obs; // default kg/week


  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
  }

  void submit() {
    accountController.saveStepData(
      data: {
        "goal_pace": paceValue.value,
      },
    );
  }

  RxString unit = "kg".obs;

  /// Convert display value automatically
  String get displayValue {
    if (unit.value == "kg") {
      return paceValue.value.toStringAsFixed(1);
    } else {
      return (paceValue.value * 2.20462).toStringAsFixed(1);
    }
  }

  void updatePace(double value) {
    paceValue.value = value;
  }

  void changeUnit(String newUnit) {
    unit.value = newUnit;
  }
}