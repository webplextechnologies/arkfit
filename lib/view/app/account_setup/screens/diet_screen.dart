import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/diet_type_controller.dart';
import 'package:ark_fit_gym/view/app/account_setup/widget/static_list.dart';
import 'package:ark_fit_gym/view/app/onboarding/controller/onboarding_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DietTypeScreen extends StatelessWidget {
  DietTypeScreen({super.key});
   final dietTypeController = Get.put(DietTypeController());

   final List<String> dietTypes = [
    "🥗  ${tr("diet_balance")}",
    "🍗  ${tr("diet_high_protein")}",
    "🥩  ${tr("diet_low_carb")}",
    "🥕  ${tr("diet_vegetarian")}",
    "🌿  ${tr("diet_vegan")}",
    "🥑  ${tr("diet_keto")}",
    "🍅  ${tr("diet_mediterranean")}",
  ];

   

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(height: 40),
        Center(child:  Text(textAlign: TextAlign.center,tr("what_diet_type"), style: AppTextStyles.headling)),

         SizedBox(height: 30),

      
        Obx(() {
          return Column(
            children: List.generate(dietTypes.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: StaticListItem(
                  title: dietTypes[index],
                  isSelected:
                      dietTypeController.selectedDietType.value == index,
                  onTap: () => dietTypeController.selectDietType(index),
                
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
