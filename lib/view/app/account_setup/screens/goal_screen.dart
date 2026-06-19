import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/main_goal_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/widget/static_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainGoalScreen extends StatelessWidget {
  MainGoalScreen({super.key});
  final mainGoalController = Get.put(MainGoalController());

   final List<String> goals = [
    "🔥  ${tr("lose_weight")}",
    "💪  ${tr("gain_muscle")}",
    "⚖️  ${tr("maintain_weight")}",
    "⚡  ${tr("fat_loss")}",
    // "🥗  Improve Nutrition",
    // "🎈  Gain Weight",
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(height: 40),
         Text(textAlign: TextAlign.center,tr("main_goal"), style: AppTextStyles.headling),

        SizedBox(height: 28),

         Obx(() {
          return Column(
            children: List.generate(goals.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StaticListItem(
                  title: goals[index],
                  isSelected:
                      mainGoalController.selectedMainGoalIndex.value == index,
                  onTap: () => mainGoalController.selectMainGoal(index),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
