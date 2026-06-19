import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/current_weight_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_unit_ruler/flutter_unit_ruler.dart';
import 'package:flutter_unit_ruler/scale_controller.dart';
import 'package:flutter_unit_ruler/scale_line.dart';
import 'package:flutter_unit_ruler/scale_unit.dart';
import 'package:get/get.dart';

class CurrentWeightScreen extends StatefulWidget {
  const CurrentWeightScreen({super.key});

  @override
  State<CurrentWeightScreen> createState() => _CurrentWeightScreenState();
}

class _CurrentWeightScreenState extends State<CurrentWeightScreen> {
  final currentWeightController = Get.put(CurrentWeightController());

  late ScaleController _unitController;
  late final ScaleUnit _scaleUnit;

  final double rulerHeight = 200;
  final double markerWidth = 5;
  bool isEditing = false;
  final TextEditingController weightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scaleUnit = UnitType.weight.kilogram;
    _unitController = ScaleController(
      value: currentWeightController.weightKg.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
         tr("current_weight"),
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
                    /*    Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentWeightController.weightText,
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentWeightController.selectedWeightUnit.value ==
                                    WeightUnit.kg
                                ? " kg"
                                : " lb",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ), */
                    Obx(() {
                      final isKg =
                          currentWeightController.selectedWeightUnit.value ==
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

                                  
                                    onSubmitted: (value) {
                                      final entered = double.tryParse(value);

                                      if (entered != null) {
                                        double kgValue = isKg
                                            ? entered
                                            : entered / 2.20462; // lb → kg
                                        _unitController.value = kgValue.round();

                                        currentWeightController.updateWeight(
                                          kgValue,
                                        );
                                      }

                                      setState(() => isEditing = false);
                                    },
                                  ),
                                )
                              : Text(
                                  currentWeightController.weightText,
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

                                /// prefill value
                                weightTextController.text =
                                    currentWeightController.weightText;
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
                        scaleMarkerPositionLeft: 13,
                        scaleMarkerPositionTop: 80,
                        scaleIntervalText: (index, value) =>
                            value.toInt().toString(),
                        scaleIntervalTextStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        scaleIntervalTextPosition: 0,
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
                        onValueChanged: (value) {
                          currentWeightController.updateWeight(
                            value.toDouble(),
                          );
                        },
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

  /// UNIT CHIP
  Widget _unitChip(String text, WeightUnit unit, double padding) {
    return Obx(() {
      final isSelected =
          currentWeightController.selectedWeightUnit.value == unit;

      return GestureDetector(
        onTap: () => currentWeightController.selectedWeightUnit.value = unit,
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

/*class CurrentWeightScreen extends StatefulWidget {
  const CurrentWeightScreen({super.key});

  @override
  State<CurrentWeightScreen> createState() => _CurrentWeightScreenState();
}

class _CurrentWeightScreenState extends State<CurrentWeightScreen> {
   late CurrentWeightController currentWeightController;

  double currentWeightInKg = 60.0;
  late ScaleController _unitController;
  late final ScaleUnit _scaleUnit;

  final double rulerHeight = 200;
  final double markerWidth = 5;

  @override
  void initState() {
    currentWeightController = Get.put(CurrentWeightController());
    _scaleUnit = UnitType.weight.kilogram;
    _unitController = ScaleController(value: currentWeightInKg);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

         Text(
          "What is your current weight?",
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
                  children: [
                    /// VALUE TEXT
                    Obx(() => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              weightText(),
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                //color: Colors.black
                              ),
                            ),
                            
                                  Text(currentWeightController.selectedWeightUnit.value ==
                                WeightUnit.kg ?
                                " kg": ' lb',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  //color: Colors.black
                                ),
                              ),
                                
                               

                          ],
                        )),

                    /// RULER
                    UnitRuler(
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
                        color: Color(0xffA1CB55),
                      ),
                      scaleMarkerPositionTop: 80,
                    
                      scaleIntervalText: (index, value) =>
                          value.toInt().toString(),
                      scaleIntervalTextStyle: const TextStyle(
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
                    
                      onValueChanged: (value) {
                        setState(() {
                          currentWeightInKg = value.toDouble();
                        });
                      }, scaleIntervalTextPosition: 0,
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
    if (currentWeightController.selectedWeightUnit.value == WeightUnit.kg) {
      return currentWeightInKg.toStringAsFixed(1);
    } else {
      final pounds = currentWeightInKg * 2.20462;
      return pounds.toStringAsFixed(1);
    }
  }

  /// UNIT CHIP
  Widget _unitChip(String text, WeightUnit unit, double padding) {
    return Obx(() {
      final isSelected = currentWeightController.selectedWeightUnit.value == unit;

      return GestureDetector(
        onTap: () => currentWeightController.selectedWeightUnit.value = unit,
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
}*/
