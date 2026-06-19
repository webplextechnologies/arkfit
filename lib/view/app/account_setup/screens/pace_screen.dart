/* import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/pace_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaceScreen extends StatefulWidget {
  const PaceScreen({super.key});

  @override
  State<PaceScreen> createState() => _PaceScreenState();
}

class _PaceScreenState extends State<PaceScreen> {
  double paceValue = 5;

  String getPaceLabel(double value) {
    if (value <= 3) return "Slow & Steady";
    if (value <= 7) return "Balanced";
    return "Fast & Aggressive";
  }

  late PaceController paceController;
  @override
  void initState() {
    paceController = Get.put(PaceController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        Text(
          tr("goal_pace"),
          textAlign: TextAlign.center,
          style: AppTextStyles.headling,
        ),

        const SizedBox(height: 40),

        Obx(
          () => Text(
            "${paceController.paceValue.toStringAsFixed(0)} kg/week",
            style: AppTextStyles.headling.copyWith(fontSize: 38.sp),
          ),
        ),

    
        SizedBox(height: 40.w),

       
        Obx(
          () => Slider(
            value: paceController.paceValue.value,
            activeColor: AppColors.secondary,
            inactiveColor: AppColors.background,
            min: 0,
            max: 10,
            //divisions: 9,
            label: paceController.paceValue.value.toStringAsFixed(0),
            onChanged: (value) {
              paceController.paceValue.value = value;
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [Text(tr("slow")), Text(tr("fast"))],
          ),
        ),
      ],
    );
  }
}
 */

import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/pace_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaceScreen extends StatefulWidget {
  const PaceScreen({super.key});

  @override
  State<PaceScreen> createState() => _PaceScreenState();
}

class _PaceScreenState extends State<PaceScreen> {
  late PaceController paceController;

  @override
  void initState() {
    paceController = Get.put(PaceController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        Text(
          tr("goal_pace"),
          textAlign: TextAlign.center,
          style: AppTextStyles.headling,
        ),

        const SizedBox(height: 30),

        /// UNIT TOGGLE
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitButton("kg"),
                SizedBox(width: 10.w),
                _unitButton("lb"),
              ],
            )),

        SizedBox(height: 30.w),

        /// VALUE TEXT
        Obx(
          () => Text(
            "${paceController.displayValue} ${paceController.unit}/week",
            style: AppTextStyles.headling.copyWith(fontSize: 38.sp),
          ),
        ),

        SizedBox(height: 40.w),

        /// SLIDER
        Obx(
          () => Slider(
            value: paceController.paceValue.value,
            activeColor: AppColors.secondary,
            inactiveColor: AppColors.background,
            min: 0.2,
            max: 1.2,
            //divisions: 10,
            label: paceController.displayValue,
            onChanged: (value) {
              paceController.updatePace(value);
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(tr("slow")), Text(tr("fast"))],
          ),
        ),
      ],
    );
  }

  Widget _unitButton(String unit) {
    return GestureDetector(
      onTap: () => paceController.changeUnit(unit),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
       
        
        decoration: BoxDecoration(
          color: paceController.unit.value == unit
              ? AppColors.secondary
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Text(
          unit.toUpperCase(),
          style: TextStyle(
            color: paceController.unit.value == unit
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}