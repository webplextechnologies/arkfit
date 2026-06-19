import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:get/get.dart';

class GenderController extends GetxController {
  Rx<Gender> selectedGender = Gender.male.obs;

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
    //accountController.onSubmit = submit;
  }

  void submit() {
  // ignore: dead_code
  if (selectedGender.value == null) {
    Get.snackbar("Error", "Please select gender");
    return;
  }

  accountController.saveStepData(
    data: {
      "gender": selectedGender.value.name, // male / female / other
    },
  );
}

}
