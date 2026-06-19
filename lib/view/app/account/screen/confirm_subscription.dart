import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/controller/current_plan_controller.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ConfirmSubscription extends StatefulWidget {
  const ConfirmSubscription({super.key});

  @override
  State<ConfirmSubscription> createState() => _ConfirmSubscriptionState();
}

class _ConfirmSubscriptionState extends State<ConfirmSubscription> {
  late CurrentPlanController currentPlanController;

  @override
  void initState() {
    super.initState();
    currentPlanController = Get.find<CurrentPlanController>();
    currentPlanController.fetchCurrentPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          /// Top Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/congratulations.png",
              width: double.infinity,
              height: Get.height * 0.32,
              fit: BoxFit.cover,
            ),
          ),

          /// Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                // ✅ Loading
                if (currentPlanController.isLoading.value) {
                  return const Center(child: CircularLoader());
                }

                final planModel = currentPlanController.currentPlanModel.value;

                // ✅ No Data
                if (planModel == null || planModel.data == null) {
                  return const Center(
                    child: Text("No subscription data found"),
                  );
                }

                final data = planModel.data!;
                final features = data.features ?? [];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Crown Icon
                    SvgPicture.asset(
                      "assets/images/crown.svg",
                      width: 100,
                      height: 100,
                    ),

                    /// Title
                    const Text(
                      "Congratulations!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Dynamic Plan Text
                    Text(
                      "You've Unlocked ${data.planName ?? ""} Subscription",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Divider(height: 32),

                    /// Benefits Title
                    const Text(
                      "Benefits Unlocked:",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ✅ Dynamic Features
                    ...features.map(
                      (e) => _feature(
                        e.title ?? "",
                        isEnabled: e.value == true || e.value is int,
                      ),
                    ),

                    const Divider(height: 32),

                    /// Footer Text
                    Text(
                      "Your subscription will automatically renew unless canceled. Manage your subscription in settings.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),

      /// Bottom Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: CustomButton(
            title: "Start Exploring Premium Features",
            onPressed: () {
              Get.offAllNamed(AppRoutes.dashboard);
            },
          ),
        ),
      ),
    );
  }

  /// ✅ Feature Widget
  Widget _feature(String text, {bool isEnabled = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isEnabled ? Icons.check : Icons.close,
            size: 20,
            color: isEnabled ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
/* class ConfirmSubscription extends StatefulWidget {
  const ConfirmSubscription({super.key});

  @override
  State<ConfirmSubscription> createState() => _ConfirmSubscriptionState();
}

class _ConfirmSubscriptionState extends State<ConfirmSubscription> {
  late CurrentPlanController currentPlanController;
  @override
  void initState() {
     currentPlanController = Get.find<CurrentPlanController>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/congratulations.png",
              width: double.infinity,
              height: Get.height * 0.32,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SvgPicture.asset(
                    "assets/images/crown.svg",
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    "Congratulations!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      // color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  //
                  Text(
                    textAlign: TextAlign.center,
                    "You've Unlocked One Year Pro Subscriptions",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      // color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Divider(height: 32),

                  Text(
                    "Benefits Unlocked:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      //color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  _feature("Ad-free experience."),
                  _feature("Advanced calorie tracking."),
                  _feature("Activity & exercise logging."),
                  _feature("Detailed progress insights."),
                  _feature("Exclusive early access."),
                  _feature("Priority customer support."),
                  const Divider(height: 32),

                  Text(
                    "Your subscription will automatically renew annually unless canceled. Manage your subscription in your account settings.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      // color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: CustomButton(
            title: "Start Exploring Premium Features",
            onPressed: () {
              Get.offAllNamed(AppRoutes.dashboard);
            },
          ),
        ),
      ),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                //color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 */