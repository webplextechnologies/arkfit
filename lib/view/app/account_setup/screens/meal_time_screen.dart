import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/meal_time_controller.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
/*
class BreakfastTimeScreen extends StatelessWidget {
  BreakfastTimeScreen({super.key});

  final timeController = Get.put(TimePickerController());

  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: 8); // 08

  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: 15); // 00

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
            "When do you usually have breakfast?",
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
                selectedIndex: timeController.selectedHour,
              ),

              const SizedBox(width: 12),

              cupertinoWheel(
                controller: minuteController,
                values: minutes,
                selectedIndex: timeController.selectedMinute,
              ),

              const SizedBox(width: 12),

               Text(
                "AM",
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
                      : Theme.of(Get.context!).brightness == Brightness.dark
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
*/



class MealTimeScreen extends StatefulWidget {
  const MealTimeScreen({super.key});

  @override
  State<MealTimeScreen> createState() => _MealTimeScreenState();
}

class _MealTimeScreenState extends State<MealTimeScreen> {


  late MealTimeController mealTimeController;
  late AccountSetUpController accountSetupController;

  final TextEditingController breakfastCtrl = TextEditingController();
  final TextEditingController lunchCtrl = TextEditingController();
  final TextEditingController snackCtrl = TextEditingController();
  final TextEditingController dinnerCtrl = TextEditingController();

  Future<void> _pickTime(
    BuildContext context,
    TextEditingController controller,
    Rx<TimeOfDay?> target,
  ) async {
    TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Theme(
        data: Theme.of(context).copyWith(
          timePickerTheme: TimePickerThemeData(
            backgroundColor:
                isDark ? Colors.grey.shade900 : Colors.white,

            hourMinuteTextColor:
                isDark ? Colors.white : Colors.black,

            hourMinuteColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? AppColors.primary
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),

            dialHandColor: AppColors.primary,
            dialBackgroundColor:
                isDark ? Colors.grey.shade800 : Colors.grey.shade200,

            entryModeIconColor: AppColors.primary,
            dayPeriodTextColor:
                isDark ? Colors.white : Colors.black,

            dayPeriodColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? AppColors.primary
                  : Colors.transparent,
            ),
          ),

          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: isDark ? Colors.grey.shade900 : Colors.white,
                onSurface: isDark ? Colors.white : Colors.black,
              ),
        ),
        child: child!,
      );
    },
  );

    if (time != null) {
      controller.text = time.format(context); // UI only
      target.value = time; // backend value
    }
  }


   // @override
  // void onInit() {
  //   super.onInit();
  //   accountController = Get.find<AccountSetUpController>();
  //   accountController.onSubmit = submit;
  // }
  @override
  void initState() {
    mealTimeController = Get.put(MealTimeController());
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(tr("meal_timing"), style: AppTextStyles.headling),

        Expanded(
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: breakfastCtrl,
                  hintText: tr("breakfast_time"),
                  readOnly: true,
                  onTap: () => _pickTime(
                    context,
                    breakfastCtrl,
                    mealTimeController.breakfast,
                  ),
                  prefixIcon: _mealIcon(),
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: lunchCtrl,
                  hintText: tr("lunch_time"),
                  readOnly: true,
                  onTap: () => _pickTime(
                    context,
                    lunchCtrl,
                    mealTimeController.lunch,
                  ),
                  prefixIcon: _mealIcon(),
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: snackCtrl,
                  hintText: tr("snack_time"),
                  readOnly: true,
                  onTap: () => _pickTime(
                    context,
                    snackCtrl,
                    mealTimeController.snack,
                  ),
                  prefixIcon: _mealIcon(),
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: dinnerCtrl,
                  hintText: tr("dinner_time"),
                  readOnly: true,
                  onTap: () => _pickTime(
                    context,
                    dinnerCtrl,
                    mealTimeController.dinner,
                  ),
                  prefixIcon: _mealIcon(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _mealIcon() {
    return const Icon(Icons.access_time_rounded, color: Colors.black26);
  }
}

