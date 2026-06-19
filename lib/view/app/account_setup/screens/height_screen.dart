import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/height_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_unit_ruler/scale_controller.dart';
import 'package:flutter_unit_ruler/scale_line.dart';
import 'package:flutter_unit_ruler/scale_unit.dart';
import 'package:get/get.dart';
import 'package:flutter_unit_ruler/flutter_unit_ruler.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  final heightController = Get.put(HeightController());

  late ScaleController _unitController;
  late final ScaleUnit _scaleUnit;

  final double rulerHeight = 200;
  final double markerWidth = 5;
  bool isEditing = false;
  final TextEditingController heightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scaleUnit = UnitType.length.centimeter;
    _unitController = ScaleController(value: heightController.heightCm.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          tr("what_height"),
          textAlign: TextAlign.center,
          style: AppTextStyles.headling,
        ),

        Expanded(
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Unit toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _unitChip("cm", HeightUnit.cm, 18),
                    SizedBox(width: Get.width * 0.1),
                    _unitChip("ft", HeightUnit.ft, 25),
                  ],
                ),

                const SizedBox(height: 30),

                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    /*  Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            heightController.heightText,
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (heightController.selectedUnit.value ==
                              HeightUnit.cm)
                            Text(
                              " cm",
                              style:  TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ), */
                    Obx(() {
                      final isCm =
                          heightController.selectedUnit.value == HeightUnit.cm;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isEditing
                              ? SizedBox(
                                  width: 140,
                                  child: TextField(
                                    controller: heightTextController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
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
                                        double cmValue;

                                        if (isCm) {
                                          /// ✅ already in cm
                                          cmValue = entered;
                                        } else {
                                        
                                          final parts = value.split('.');
                                          int feet =
                                              int.tryParse(parts[0]) ?? 0;
                                          int inches = parts.length > 1
                                              ? int.tryParse(parts[1]) ?? 0
                                              : 0;

                                          final totalInches =
                                              (feet * 12) + inches;
                                          cmValue = totalInches * 2.54;
                                        }

                                        heightController.updateHeight(cmValue);
                                      }

                                      setState(() => isEditing = false);
                                    },
                                  ),
                                )
                              : Text(
                                  heightController.heightText,
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                          Text(
                            isCm ? " cm" : " ft/in",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// ✏️ EDIT BUTTON
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditing = true;

                                /// Prefill value
                                if (isCm) {
                                  heightTextController.text = heightController
                                      .heightCm
                                      .value
                                      .toStringAsFixed(1);
                                } else {
                                  final totalInches =
                                      (heightController.heightCm.value / 2.54)
                                          .round();
                                  final feet = totalInches ~/ 12;
                                  final inches = totalInches % 12;

                                  /// format like 5.8
                                  heightTextController.text = "$feet.$inches";
                                }
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

                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: UnitRuler(
                        height: rulerHeight,
                        width: MediaQuery.of(context).size.width,
                        scaleUnit: _scaleUnit,
                        controller: _unitController,
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
                        scaleMarkerPositionTop: 90,
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
                          heightController.updateHeight(value.toDouble());
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

  /// Unit toggle chip
  Widget _unitChip(String text, HeightUnit unit, double padding) {
    return Obx(() {
      final isSelected = heightController.selectedUnit.value == unit;

      return GestureDetector(
        onTap: () => heightController.selectedUnit.value = unit,
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
