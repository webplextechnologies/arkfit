import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameScreenController extends GetxController {
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();

  late AccountSetUpController accountController;

  @override
  void onInit() {
    super.onInit();
    accountController = Get.find<AccountSetUpController>();
   // accountController.onSubmit = submit;
  }

  void submit() {
    if (firstNameCtrl.text.isEmpty) {
      Get.snackbar("Error", "Please enter first name");
      return;
    }

    accountController.saveStepData(
      data: {
        "first_name": firstNameCtrl.text,
        "last_name": lastNameCtrl.text,
      },
    );
  }
}
