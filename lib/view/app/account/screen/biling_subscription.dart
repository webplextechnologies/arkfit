import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/account/controller/current_plan_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BilingSubscription extends StatefulWidget {
  const BilingSubscription({super.key});

  @override
  State<BilingSubscription> createState() => _BilingSubscriptionState();
}

class _BilingSubscriptionState extends State<BilingSubscription> {
  late CurrentPlanController currentPlanController;
  @override
  void initState() {
    currentPlanController = Get.put(CurrentPlanController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          tr("billing"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
       
        if (currentPlanController.isLoading.value) {
          return const Center(child: CircularLoader());
        }

        final planModel = currentPlanController.currentPlanModel.value;

        if (planModel.data == null) {
          return Center(
            child: Text("No plan found", style: TextStyle(fontSize: 20.sp)),
          );
        }

        final data = planModel.data!;

        final featureList = data.features ?? [];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: _premiumCard(
            planName: data.planName ?? "",
            price: data.price ?? "0",
            isActive: planModel.hasActivePlan == true,
            daysLeft: data.daysLeft ?? 0,
            features: featureList,
          ),
        );
      }),
    );
  }

  Widget _premiumCard({
    required String planName,
    required String price,
    required bool isActive,
    required int daysLeft,
    required List features,
  }) {
    return Stack(
      children: [
        Container(
          padding:  EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               SizedBox(height: 8.w),

              // ✅ Plan Name
              Text(
                planName,
                style:  TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              // ✅ Price
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$$price",
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: isActive ? " / month" : " / free",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Status
              Text(
                isActive ? "Active Plan" : "Free Plan",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isActive ? Colors.green : Colors.grey,
                ),
              ),

              // ✅ Days Left
              if (isActive)
                Padding(
                  padding:  EdgeInsets.only(top: 6.w),
                  child: Text(
                    "Days left: $daysLeft",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),

               Divider(height: 32.w),

              // ✅ Features (Dynamic)
              ...features.map<Widget>((e) {
                return _feature(
                  e.title ?? "",
                  isEnabled: e.value == true || e.value is int,
                );
              }).toList(),

              const Divider(height: 32),

              Text(
                "Your current plan",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

        // ✅ Badge (only for paid plan)
        if (isActive)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Text(
                "Active",
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

  Widget _feature(String text, {bool isEnabled = false}) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 6.w),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check : Icons.close,
            size: 20.sp,
            color: isEnabled ? Colors.green : Colors.red,
          ),
           SizedBox(width: 10.w),
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
