import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/activity_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/widget/static_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AcitivyLevelScreen extends StatelessWidget {
  AcitivyLevelScreen({super.key});

  final activityController = Get.put(ActivityController());

  final List<String> activities = [
    "🛋️  ${tr("exercise_low")}",
    "🚶‍♂️  ${tr("exercise_1_2")}",
    "🏃‍♀️  ${tr("exercise_3_4")}",
    "💪  ${tr("exercise_5_plus")}",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(height: 40),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            tr("activity_goal"),
            style: AppTextStyles.headling,
          ),
        ),

        SizedBox(height: 30),

        Obx(() {
          return Column(
            children: List.generate(activities.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StaticListItem(
                  title: activities[index],
                  isSelected:
                      activityController.selectedActivityIndex.value == index,
                  onTap: () => activityController.selectActivity(index),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
