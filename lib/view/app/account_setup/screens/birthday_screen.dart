import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/birthday_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class BirthdayScreen extends StatelessWidget {
  BirthdayScreen({super.key});

  final controller = Get.put(BirthdayController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),

            Text(
              tr("birthday"),
              style: AppTextStyles.headling,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30.h),

            /// Labels
            Row(
              children: [
                _label(tr("month")),
                _label(tr("day")),
                _label(tr("year")),
              ],
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 50.w,
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      border: BoxBorder.fromLTRB(
                        top: BorderSide(color: AppColors.primary, width: 1),
                        bottom: BorderSide(color: AppColors.primary, width: 1),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(child: _monthPicker()),
                      Expanded(child: _dayPicker()),
                      Expanded(child: _yearPicker()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            // color: Colors.grey,
          ),
        ),
      ),
    );
  }

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  Widget _monthPicker() {
    return Obx(() {
      return CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: controller.selectedMonthIndex.value,
        ),
        itemExtent: 48.h,
        useMagnifier: true,
        magnification: 1.2.h,

        onSelectedItemChanged: (i) {
          HapticFeedback.selectionClick();
          controller.selectedMonthIndex.value = i;
          controller.updateMonth(controller.months[i]);
        },

        children: List.generate(controller.months.length, (index) {
          final isSelected = index == controller.selectedMonthIndex.value;

          return Center(
            child: Text(
              twoDigits(controller.months[index]),
              style: TextStyle(
                fontSize: isSelected ? 28.sp : 24.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(Get.context!).iconTheme.color,
                //Colors.grey,
              ),
            ),
          );
        }),
      );
    });
  }

  /// ------------------ DAY PICKER ------------------
  Widget _dayPicker() {
    return Obx(() {
      return CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: controller.selectedDayIndex.value,
        ),
        itemExtent: 48.h,
        useMagnifier: true,
        magnification: 1.2.h,

        onSelectedItemChanged: (i) {
          HapticFeedback.selectionClick();
          controller.selectedDayIndex.value = i;
          controller.updateDay(controller.days[i]);
        },

        children: List.generate(controller.days.length, (index) {
          final isSelected = index == controller.selectedDayIndex.value;

          return Center(
            child: Text(
              twoDigits(controller.days[index]),
              style: TextStyle(
                fontSize: isSelected ? 28.sp : 24.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(Get.context!).iconTheme.color,
              ),
            ),
          );
        }),
      );
    });
  }

  /// ------------------ YEAR PICKER ------------------
  Widget _yearPicker() {
    return Obx(() {
      return CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: controller.selectedYearIndex.value,
        ),
        itemExtent: 48.h,
        useMagnifier: true,
        magnification: 1.2.h,
        onSelectedItemChanged: (i) {
          HapticFeedback.selectionClick();
          controller.selectedYearIndex.value = i;
          controller.updateYear(controller.years[i]);
        },

        children: List.generate(controller.years.length, (index) {
          final isSelected = index == controller.selectedYearIndex.value;

          return Center(
            child: Text(
              controller.years[index].toString(),
              style: TextStyle(
                fontSize: isSelected ? 28.sp : 24.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(Get.context!).iconTheme.color,
              ),
            ),
          );
        }),
      );
    });
  }
}
