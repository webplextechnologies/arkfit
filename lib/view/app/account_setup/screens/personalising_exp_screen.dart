
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/account_setup/controller/account_setup_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalisingExpScreen extends StatefulWidget {
  const PersonalisingExpScreen({super.key});

  @override
  State<PersonalisingExpScreen> createState() => _PersonalisingExpScreenState();
}

class _PersonalisingExpScreenState extends State<PersonalisingExpScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<AccountSetUpController>();

  late AnimationController progressController;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    progressController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startPersonalising();
    });
  }

  Future<void> startPersonalising() async {
    await controller.getNutritionPlan();

    await Future.delayed(const Duration(seconds: 1));

    /// Move to next step
    controller.currentStep.value++;
    controller.step.value = controller.currentStep.value - 1;

    controller.update();
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        Text(
          tr("personalizing"),
          textAlign: TextAlign.center,
          style: AppTextStyles.headling,
        ),

        const SizedBox(height: 30),

        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: progressController,
              builder: (context, child) {
                double value = progressController.value;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180.w,
                          height: 180.w,
                          child: CircularProgressIndicator(
                            strokeCap: StrokeCap.round,
                            value: value,
                            strokeWidth: 10.w,
                            backgroundColor: Colors.white,
                            color: AppColors.primary,
                          ),
                        ),

                        Text(
                          "${(value * 100).toInt()}%",
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  /*   SizedBox(height: 20.w),
                    Text(
                      tr("goal_time"),
                     // "You will achieve your goal in ${controller.nutrition.value.goalPlan?.estimatedMonths} months",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,

                        fontWeight: FontWeight.w500,
                      ),
                    ), */
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
