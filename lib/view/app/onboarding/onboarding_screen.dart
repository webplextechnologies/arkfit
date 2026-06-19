import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/auth/welcome_screen.dart';
import 'package:ark_fit_gym/view/app/onboarding/controller/onboarding_controller.dart';
import 'package:ark_fit_gym/view/widgets/top_curve_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingController onboardingController;
  final PageController _pageController = PageController();

  final onboardingData = [
    {
      "light": "assets/images/onboarding_1.png",
      "dark": "assets/images/onboarding_1_dark.png",
      "title": "ARKfit - Personalized Tracking Made Easy",
      "subtitle":
          "Log your meals, track activities, steps, weight,\n BMI, and monitor hydration with tailored\n insights just for you.",
    },

    {
      "light": "assets/images/onboarding_2.png",
      "dark": "assets/images/onboarding_2_dark.png",
      "title": "Gain Clear Insights Into Your Progress",
      "subtitle":
          "See how your daily efforts stack up with\n detailed graphs and reports on calories,\n arkfit, and fitness.",
    },
  ];

  @override
  void initState() {
    onboardingController = Get.put(OnboardingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                onboardingController.pageIndex.value = index;
              },
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return Center(
                  child: Image.asset(
                    isDark ? data["dark"]! : data["light"]!,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            ///  FIXED BOTTOM CARD
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: TopCurveClipper(),
                child: Container(
                  //height: Get.height * 0.42,
                  height: 360.h,

                  width: double.infinity,
                  padding: EdgeInsets.all(15.w),
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.h),
                      Obx(
                        () => Text(
                          onboardingData[onboardingController
                              .pageIndex
                              .value]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Obx(
                        () => Text(
                          onboardingData[onboardingController
                              .pageIndex
                              .value]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            // color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: onboardingController.pageIndex.value == i
                                  ? 20.w
                                  : 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: onboardingController.pageIndex.value == i
                                    ? AppColors.primary
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.w),

                      /// BUTTONS (FIXED)
                      Row(
                        children: [
                          /// SKIP
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // _pageController.previousPage(
                                //   duration: const Duration(milliseconds: 300),
                                //   curve: Curves.easeInOut,
                                // );
                                Get.offAll(() => WelcomeScreen());
                               
                              },
                              child: Container(
                                height: 45.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.w),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child:  Center(
                                  child: Text(
                                    "Skip",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      //color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 20.w),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (onboardingController.pageIndex.value <
                                    onboardingData.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  Get.to(() => WelcomeScreen());
                                }
                              },
                              child: Container(
                                height: 45.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.w),
                                  color: AppColors.primary,
                                ),
                                child: Center(
                                  child: Text(
                                    "Continue",
                                    style: AppTextStyles.button,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
