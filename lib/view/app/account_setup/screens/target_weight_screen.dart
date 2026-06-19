import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/target_weight_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_unit_ruler/flutter_unit_ruler.dart';
import 'package:flutter_unit_ruler/scale_controller.dart';
import 'package:flutter_unit_ruler/scale_line.dart';
import 'package:flutter_unit_ruler/scale_unit.dart';
import 'package:get/get.dart';

class TargetWeightScreen extends StatefulWidget {
  const TargetWeightScreen({super.key});

  @override
  State<TargetWeightScreen> createState() => _TargetWeightScreenState();
}

class _TargetWeightScreenState extends State<TargetWeightScreen> {
  late TargetWeightController targetWeightController;

  late ScaleController _unitController;
  late final ScaleUnit _scaleUnit;

  final double rulerHeight = 200;
  final double markerWidth = 5;

  bool isEditing = false;
  final TextEditingController weightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    targetWeightController = Get.put(TargetWeightController());

    _scaleUnit = UnitType.weight.kilogram;

    /// Initialize ruler from controller value
    _unitController = ScaleController(
      value: targetWeightController.targetWeightKg.value,
    );

    /// Register submit callback
    targetWeightController.accountController.onSubmit =
        targetWeightController.submit;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        Text(
          tr("what_target_weight"),
          textAlign: TextAlign.center,
          style: AppTextStyles.headling,
        ),

        Expanded(
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// UNIT SWITCH
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _unitChip("kg", WeightUnit.kg, 20),
                    SizedBox(width: Get.width * 0.1),
                    _unitChip("lb", WeightUnit.lb, 24),
                  ],
                ),

                const SizedBox(height: 30),

                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    /// VALUE TEXT
                    /*   Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            weightText(),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            targetWeightController.selectedWeightUnit.value ==
                                    WeightUnit.kg
                                ? " kg"
                                : " lb",
                            style:  TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ), */
                    Obx(() {
                      final isKg =
                          targetWeightController.selectedWeightUnit.value ==
                          WeightUnit.kg;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isEditing
                              ? SizedBox(
                                  width: 120,
                                  child: TextField(
                                    controller: weightTextController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    autofocus: true,
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),

                                    /// 🔥 When user submits
                                    onSubmitted: (value) {
                                      final entered = double.tryParse(value);

                                      if (entered != null) {
                                        double kgValue = isKg
                                            ? entered
                                            : entered / 2.20462; // lb → kg
                                        _unitController.value = kgValue.round();
                                        targetWeightController.updateWeight(
                                          kgValue,
                                        );
                                      }

                                      setState(() => isEditing = false);
                                    },
                                  ),
                                )
                              : Text(
                                  weightText(),
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                          Text(
                            isKg ? " kg" : " lb",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// 🔥 EDIT BUTTON
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditing = true;
                                weightTextController.text = weightText();
                              });
                            },
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      );
                    }),

                    /// RULER
                    Padding(
                       padding:  EdgeInsets.only(top: 50.w),
                      child: UnitRuler(
                        scaleMarkerPositionLeft: 13,
                        height: rulerHeight,
                        width: MediaQuery.of(context).size.width,
                        controller: _unitController,
                        scaleUnit: _scaleUnit,
                        scrollDirection: Axis.horizontal,
                        backgroundColor: Colors.transparent,
                        scaleAlignment: Alignment.center,
                        scalePadding: EdgeInsets.zero,
                      
                        scaleMarker: Container(
                          width: markerWidth,
                          height: Get.width * 0.2,
                          color: const Color(0xffA1CB55),
                        ),
                        scaleMarkerPositionTop: 80,
                      
                        scaleIntervalText: (index, value) =>
                            value.toInt().toString(),
                        scaleIntervalTextStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      
                        scaleIntervalStyles: const [
                          ScaleIntervalStyle(
                            color: Colors.grey,
                            width: 1,
                            height: 35,
                            scale: -1,
                          ),
                          ScaleIntervalStyle(
                            color: Colors.grey,
                            width: 2,
                            height: 70,
                            scale: 1,
                          ),
                        ],
                      
                        /// 🔑 UPDATE CONTROLLER VALUE
                        onValueChanged: (value) {
                          targetWeightController.updateWeight(value.toDouble());
                        },
                      
                        scaleIntervalTextPosition: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// DISPLAY TEXT
  String weightText() {
    final kg = targetWeightController.targetWeightKg.value;

    if (targetWeightController.selectedWeightUnit.value == WeightUnit.kg) {
      return kg.toStringAsFixed(1);
    } else {
      return (kg * 2.20462).toStringAsFixed(1);
    }
  }

  /// UNIT CHIP
  Widget _unitChip(String text, WeightUnit unit, double padding) {
    return Obx(() {
      final isSelected =
          targetWeightController.selectedWeightUnit.value == unit;

      return GestureDetector(
        onTap: () {
          targetWeightController.selectedWeightUnit.value = unit;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? AppColors.secondary : Colors.black45,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}

