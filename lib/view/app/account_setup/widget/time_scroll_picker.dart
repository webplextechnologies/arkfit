import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TimeScrollPicker extends StatelessWidget {
  TimeScrollPicker({super.key});
  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: 3); // 08

  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: 0); // 00

  final List<String> hours = List.generate(
    12,
    (i) => i.toString().padLeft(2, '0'),
  ); // 00–12

  final List<String> minutes = List.generate(
    60,
    (i) => i.toString().padLeft(2, '0'),
  ); // 00–59

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, -0.5),
      children: [
      

        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //cupertinoWheel(controller: hourController, values: hours, selectedIndex: null),

            const SizedBox(width: 12),

           // cupertinoWheel(controller: minuteController, values: minutes, selectedIndex: null),

            const SizedBox(width: 12),

             Text(
              "AM",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget border() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.primary, width: 2),
          bottom: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
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
    height: 260,
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
                    ? const Color(0xFF34C759) // iOS green
                    : const Color(0xFFBDBDBD),
              ),
            ),
          );
        }),
      ),
    ),
  );
}
}
