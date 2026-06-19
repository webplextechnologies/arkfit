import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CaloriePlanScreen extends StatelessWidget {
  const CaloriePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountSetUpController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40.h),

        Text(
          tr("calorie_plan_ready"),
          textAlign: TextAlign.center,
          style: AppTextStyles.headling,
        ),

        SizedBox(height: 20.h),

        Expanded(
          child: Obx(() {
            final data = controller.nutrition.value;

            /// Convert grams → calories
            double proteinCal = (data.macros?.proteinGrams ?? 0) * 4;
            double carbsCal = (data.macros?.carbsGrams ?? 0) * 4;
            double fatCal = (data.macros?.fatGrams ?? 0) * 9;

            double total = proteinCal + carbsCal + fatCal;

            if (total == 0) {
              return const Center(child: CircularProgressIndicator());
            }

            double proteinPercent = (proteinCal / total) * 100;
            double carbsPercent = (carbsCal / total) * 100;
            double fatPercent = (fatCal / total) * 100;

            return Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4.w,
                    centerSpaceRadius: 70.r,
                    sections: [
                      PieChartSectionData(
                        value: proteinPercent,
                        color: Colors.red,
                        title: "${proteinPercent.toStringAsFixed(0)}%",
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      PieChartSectionData(
                        value: carbsPercent,
                        color: Colors.green,
                        title: "${carbsPercent.toStringAsFixed(0)}%",
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      PieChartSectionData(
                        value: fatPercent,
                        color: Colors.orange,
                        title: "${fatPercent.toStringAsFixed(0)}%",
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Center Calories
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${data.dailyCalories ?? 0}",
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text("kcal/day", style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ],
            );
          }),
        ),

        SizedBox(height: 20.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 6.r, backgroundColor: Colors.red),
                  SizedBox(width: 6.w),
                  Text(tr("protein")),
                ],
              ),

              Row(
                children: [
                  CircleAvatar(radius: 6.r, backgroundColor: Colors.green),
                  SizedBox(width: 6.w),
                  Text(tr("carbs")),
                ],
              ),

              Row(
                children: [
                  CircleAvatar(radius: 6.r, backgroundColor: Colors.orange),
                  SizedBox(width: 6.w),
                  Text(tr("fat")),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        Obx(
          () => Text(
            tr(
              "goal_time",
              namedArgs: {
                "months":
                    "${controller.nutrition.value.goalPlan?.estimatedMonths ?? 0}",
              },
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),

        SizedBox(height: 20.w),
      ],
    );
  }
}
