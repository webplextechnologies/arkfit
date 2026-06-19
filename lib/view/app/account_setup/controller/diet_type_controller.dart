import 'package:get/get.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';

class DietTypeController extends GetxController {
  /// UI selected index
  RxInt selectedDietType = (-1).obs;

  /// Backend values (order MUST match UI list)
  final List<String> backendDietTypes = [
    "balance_diet",
    "high_protein",
    "low_carb",
    "vegetarian",
    "vegan",
    "keto",
    "mediterranean",
  ];

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();

    /// Register submit handler
    //accountController.onSubmit = submit;
  }

  void selectDietType(int index) {
    selectedDietType.value = index;
  }

  /// 🔑 SEND DATA TO BACKEND
  void submit() {
    if (selectedDietType.value == -1) {
      Get.snackbar("Error", "Please select a diet type");
      return;
    }

    final dietValue = backendDietTypes[selectedDietType.value];

    accountController.saveStepData(
      data: {
        "diet_type": dietValue,
      },
      
    );
  }
}
