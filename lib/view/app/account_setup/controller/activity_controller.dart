import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {

  RxInt selectedActivityIndex = (-1).obs;
  final List<String> backendActivity = [
    "dont",
    "1_2days",
    "3_4days",
    "5_days_plus",
  ];

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
    // Register submit handler
    // accountController.onSubmit = submit;
  }

  void selectActivity(int index) {
    selectedActivityIndex.value = index;
  }

  void submit() {
    if (selectedActivityIndex.value == -1) {
      Get.snackbar("Error", "Please select a Activity type");
      return;
    }

    final activityValue = backendActivity[selectedActivityIndex.value];
    accountController.saveStepData(data: {"activity_level": activityValue});
  }
}
