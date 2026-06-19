/* import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/controller/upgrade_plan_controller.dart';
import 'package:ark_fit_gym/view/app/account/screen/choose_payment_methods.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpgradePlan extends StatefulWidget {
  const UpgradePlan({super.key});

  @override
  State<UpgradePlan> createState() => _UpgradePlanState();
}

class _UpgradePlanState extends State<UpgradePlan> {
  int selectedTab = 0;
  late UpgradePlanController upgradePlanController;
  @override
  void initState() {
    upgradePlanController = Get.put(UpgradePlanController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(tr("upgrade"),style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _tabBar(),
            const SizedBox(height: 20),
            if (selectedTab == 0) _monthlyCard() else _premiumCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding:  EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: CustomButton(
            title: selectedTab == 1
                ? "Continue - \$9.99" : selectedTab == 2 ? "Continue - \$49.99" : "Continue - Free",
              
            onPressed: () {
              Get.to(() => ChoosePaymentMethod()); // Navigate to
            },
          ),
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_tabItem("Free", 0), _tabItem(tr('monthly'), 1), _tabItem(tr('yearly'), 2)],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
   
   Widget _monthlyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),

          const Text(
            "ARKfit Premium",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              // color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

        
           RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$8.99",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: " / month",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

          const Divider(height: 32),

          _feature("Personalized daily calorie target"),
          _feature("Macro tracking (Protein / Carbs / Fat)"),
          _feature("Meal logging"),
          _feature("Breakfast / Lunch / Dinner / Snack"),
          _feature("Water tracking"),
          _feature("Manual activity/workout logging"),
        ],
      ),
    );
  }

  Widget _premiumCard() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              const Text(
                "ARKfit Premium",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  // color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$49.99",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: " / year",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              _feature("Barcode scanner"),
              _feature("Export analytic report PDF"),
              _feature("Micro-nutrient tracker"),
              _feature("Smart AI nutritional suggestions"),
              _feature("Remove ads forever"),
              _feature("Snap Meel calorie detection"),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child:  Text(
              "Save 16%",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.check,
            size: 20,
            color: Theme.of(context).iconTheme.color!,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                // color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/controller/upgrade_plan_controller.dart';
import 'package:ark_fit_gym/view/app/account/model/subscription_plans_model.dart';
import 'package:ark_fit_gym/view/app/account/screen/choose_payment_methods.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpgradePlan extends StatefulWidget {
  const UpgradePlan({super.key});

  @override
  State<UpgradePlan> createState() => _UpgradePlanState();
}

class _UpgradePlanState extends State<UpgradePlan> {
  int selectedTab = 0;
  late UpgradePlanController controller;

  @override
  void initState() {
    controller = Get.put(UpgradePlanController());
    super.initState();
  }

  String getDurationLabel(String days) {
    int d = int.tryParse(days) ?? 0;

    if (d >= 3650) return "lifetime";
    if (d == 30) return "month";
    if (d == 365) return "year";

    return "$d days";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("upgrade"),
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// ✅ Tabs
            _tabBar(),

            SizedBox(height: 20.w),

            /// ✅ Plan Card
            Expanded(child: _planCard()),
          ],
        ),
      ),

      /// ✅ Bottom Button
      bottomNavigationBar: Obx(() {
        final plans = controller.subscriptionPlans;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomButton(
              title: plans.isEmpty
                  ? tr("continue")
                  : "${tr("continue")} - \$${plans[selectedTab].price}",
              onPressed: () {
               /*   Get.to(
                  () => ChoosePaymentMethod(
                    amount: plans[selectedTab].price.toString(),
                 )); */
                  controller.createPayment(
                    plans[selectedTab].id,
                    plans[selectedTab].price.toString(),
                   
                    );
                
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _tabBar() {
    return Obx(() {
      final plans = controller.subscriptionPlans;

      if (plans.isEmpty) {
        return const SizedBox();
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: List.generate(plans.length, (index) {
            final selected = selectedTab == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedTab = index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.w),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    plans[index].name ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _planCard() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularLoader());
      }

      final plans = controller.subscriptionPlans;

      if (plans.isEmpty) {
        return const Center(child: Text("No Plans Available"));
      }

      final plan = plans[selectedTab];

      return Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(color: Colors.white, width: 1.w),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
              ],
            ),

            child: Column(
              children: [
                SizedBox(height: 10.w),

                Text(
                  plan.name ?? "",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$${plan.price}",
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " / ${getDurationLabel(plan.durationDays ?? "0")}",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),

                const Divider(height: 30),

                Column(
                  children:
                      plan.features?.map((feature) {
                        return _featureRow(feature);
                      }).toList() ??
                      [],
                ),
              ],
            ),
          ),

          /// ✅ Badge for yearly
          if (plan.durationDays == "365")
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
                child: Text(
                  "Best Value",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _featureRow(FeatureModel feature) {
    final isEnabled = feature.value == true;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.w),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check : Icons.close,
            size: 18.w,
            color: isEnabled ? Colors.green : Colors.red,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "${feature.title} ${feature.value is String ? "- ${feature.value}" : ""}",
            ),
          ),
        ],
      ),
    );
  }
}
