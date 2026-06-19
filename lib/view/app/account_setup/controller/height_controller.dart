import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:get/get.dart';

class HeightController extends GetxController {
  /// Selected unit for UI only
  Rx<HeightUnit> selectedUnit = HeightUnit.cm.obs;

  /// Height always stored in CM (backend format)
  RxDouble heightCm = 152.0.obs;

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
    //accountController.onSubmit = submit;
  }

  /// Called when ruler value changes
  void updateHeight(double valueInCm) {
    heightCm.value = valueInCm;
  }

  /// Height value sent to API
  int get heightForApi => heightCm.value.round();

  /// Height text shown in UI
  String get heightText {
    if (selectedUnit.value == HeightUnit.cm) {
      return heightCm.value.toStringAsFixed(1);
    } else {
      final totalInches = (heightCm.value / 2.54).round();
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return "$feet' $inches\"";
    }
  }

  /// Submit height to onboarding API
  void submit() {
    accountController.saveStepData(
      data: {
        "height_cm": heightCm.value,
      },
    );
  }
}
