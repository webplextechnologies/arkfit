import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:get/get.dart';

class MainGoalController extends GetxController {
   RxInt selectedMainGoalIndex = (-1).obs;




    final List<String> backendGoals = [
    "weight_loss",
    "muscle_gain",
    "maintenance",
    "fat_loss",
    // "boost_energy",
    // "improve_nutrition",
    // "gain_weight",
  ];

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();

    /// Register submit handler
    //accountController.onSubmit = submit;
  }

  void selectMainGoal(int index) {
    selectedMainGoalIndex.value = index;
  }

  /// 🔑 SEND DATA TO BACKEND
  void submit() {
    if (selectedMainGoalIndex.value == -1) {
      Get.snackbar("Error", "Please select a diet type");
      return;
    }

    final dietValue = backendGoals[selectedMainGoalIndex.value];

    accountController.saveStepData(
      data: {
        "goal": dietValue,
      },
      
    );
  }
}
