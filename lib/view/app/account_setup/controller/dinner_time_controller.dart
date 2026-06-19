import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class DinnerTimeController extends GetxController {
  // Selected indexes
  final selectedHour = 8.obs;
  final selectedMinute = 0.obs;
  final selectedPeriod = 0.obs; // 0 = AM, 1 = PM

  // Scroll controllers
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController periodController;

  final hours =
      List.generate(13, (i) => i.toString().padLeft(2, '0'));
  final minutes =
      List.generate(60, (i) => i.toString().padLeft(2, '0'));

  @override
  void onInit() {
    hourController =
        FixedExtentScrollController(initialItem: selectedHour.value);
    minuteController =
        FixedExtentScrollController(initialItem: selectedMinute.value);
    periodController =
        FixedExtentScrollController(initialItem: selectedPeriod.value);
    super.onInit();
  }
}
