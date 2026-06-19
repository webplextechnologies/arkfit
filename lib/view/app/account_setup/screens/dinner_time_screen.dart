import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/dinner_time_controller.dart';
import 'package:ark_fit_gym/view/app/onboarding/controller/onboarding_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DinnerTimeScreen extends StatelessWidget {
  DinnerTimeScreen({super.key});

  final dinnerTimeController = Get.put(DinnerTimeController());

  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: 8); 

  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: 15); 

  final List<String> hours = List.generate(
    13,
    (i) => i.toString().padLeft(2, '0'),
  ); // 00–12

  final List<String> minutes = List.generate(
    60,
    (i) => i.toString().padLeft(2, '0'),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(height: 40),
        Center(
          child:  Text(
            textAlign: TextAlign.center,
            "When do you usually have dinner?",
            style: AppTextStyles.headling,
          ),
        ),

        Expanded(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              cupertinoWheel(
                controller: hourController,
                values: hours,
                selectedIndex: dinnerTimeController.selectedHour,
              ),

              const SizedBox(width: 12),

              cupertinoWheel(
                controller: minuteController,
                values: minutes,
                selectedIndex: dinnerTimeController.selectedMinute,
              ),

              const SizedBox(width: 12),

               Text(
                "PM",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                   color:Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black54,
                
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cupertinoWheel({
    required FixedExtentScrollController controller,
    required List<String> values,
    required RxInt selectedIndex,
    double width = 80,
  }) {
    return SizedBox(
      width: width,
      height: Get.height*0.8,
      child: Obx(
        () => CupertinoPicker(
          scrollController: controller,
          itemExtent: 48,
          useMagnifier: true,
          magnification: 1.2,
          selectionOverlay: const SizedBox(),
          onSelectedItemChanged: (index) {
            selectedIndex.value = index;
          },
          children: List.generate(values.length, (index) {
            final isSelected = index == selectedIndex.value;
            return Center(
              child: Text(
                values[index],
                style: TextStyle(
                  fontSize: isSelected ? 30 : 24,
                   
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.primary // iOS green
                      :    Theme.of(Get.context!).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black54,
                
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
