import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/gender_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GenderScreen extends StatelessWidget {
  GenderScreen({super.key});
  final genderController = Get.put(GenderController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(height: 40),
        Text(tr("whats_your_gender"), style: AppTextStyles.headling),
        Expanded(
          child: Align(
            alignment: const Alignment(0, -0.5),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            genderController.selectedGender.value = Gender.male,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor:
                                  genderController.selectedGender.value ==
                                      Gender.male
                                  ? AppColors.primary
                                  : Colors.white,
                              child: SvgPicture.asset(
                                "assets/icons/gender_male.svg",
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                                color:
                                    genderController.selectedGender.value ==
                                        Gender.male
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(height: Get.width * 0.02),
                            Text(
                              tr("male"),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color:
                                    genderController.selectedGender.value ==
                                        Gender.male
                                    ? AppColors.primary
                                    : Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Get.width * 0.1),
                      GestureDetector(
                        onTap: () => genderController.selectedGender.value =
                            Gender.female,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor:
                                  genderController.selectedGender.value ==
                                      Gender.female
                                  ? AppColors.primary
                                  : Colors.white,
                              child: SvgPicture.asset(
                                "assets/icons/gender_female.svg",
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                                color:
                                    genderController.selectedGender.value ==
                                        Gender.female
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(height: Get.width * 0.02),
                            Text(
                              tr("female"),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color:
                                    genderController.selectedGender.value ==
                                        Gender.female
                                    ? AppColors.primary
                                    : Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () =>
                        genderController.selectedGender.value = Gender.other,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color:
                            genderController.selectedGender.value ==
                                Gender.other
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color:
                              genderController.selectedGender.value ==
                                  Gender.other
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ),

                      child: Text(
                        tr("prefer_not_say"),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color:
                              genderController.selectedGender.value ==
                                  Gender.other
                              ? Colors.white
                              : Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
