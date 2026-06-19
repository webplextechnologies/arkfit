import 'dart:ui';
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/account/screen/upgrade_plan.dart';
import 'package:ark_fit_gym/view/app/activity/activity_screen.dart';
import 'package:ark_fit_gym/view/app/addMeals/screens/meal_screen.dart';
import 'package:ark_fit_gym/view/app/home/controller/home_controller.dart';
import 'package:ark_fit_gym/view/app/notification/notification_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController homeController;

  @override
  void initState() {
    homeController = Get.put(HomeController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/icons/icon.png"),
                Text(
                  "ARKfit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => NotificationScreen()),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0).w,
                      child: SvgPicture.asset(
                        'assets/icons/Notification.svg',
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        height: 24.w,
                        width: 24.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            color: Theme.of(context).iconTheme.color,
            onRefresh: () async {
              await homeController.dashboardData(
                showLoader: false,
                homeController.selectedDate.value,
              );
            },
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/home_bg.png",
                    // width: 1.sw,
                    height: 0.32.sh,
                    fit: BoxFit.cover,
                  ),
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 20.w,
                      ),
                      child: Column(
                        children: [
                          Obx(() {
                            final isPremium =
                                homeController.isPremiumUser.value;
                            return Container(
                              width: 0.85.sw,
                              padding: EdgeInsets.symmetric(
                                vertical: 15.w,
                                horizontal: 20.w,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.w,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            homeController.previousDay(),
                                        child: Icon(
                                          Icons.chevron_left,
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color!,
                                          size: 30.w,
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () =>
                                            homeController.selectDate(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Obx(
                                              () => Text(
                                                homeController
                                                        .selectedDateText
                                                        .isEmpty
                                                    ? "Today"
                                                    : "${homeController.selectedDateText.value}  ",
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/calendar.svg',
                                              colorFilter: ColorFilter.mode(
                                                Theme.of(
                                                  context,
                                                ).iconTheme.color!,
                                                BlendMode.srcIn,
                                              ),
                                              height: 20.w,
                                              width: 20.w,
                                            ),
                                          ],
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () => homeController.nextDay(),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color!,
                                          size: 30.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "🥗 ${tr("eaten")}",
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "${homeController.calories.value.consumed ?? 0}",
                                              //maxLines: 1,
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    26.sp, // slightly reduced
                                              ),
                                            ),
                                            Text(
                                              "kcal",
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      SizedBox(
                                        width: 110.w,
                                        height: 110.w,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 100.w,
                                              height: 100.w,
                                              child: CircularProgressIndicator(
                                                strokeCap: StrokeCap.round,
                                                value:
                                                    ((homeController
                                                            .calories
                                                            .value
                                                            .percentage ??
                                                        0.0) /
                                                    100),

                                                strokeWidth: 8.w,
                                                backgroundColor: Color(
                                                  0xffececec,
                                                ),
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                      AppColors.primary,
                                                    ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "${homeController.calories.value.remaining ?? 0}",
                                                  style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  "kcal left",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "🔥 ${tr("burned")}",
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "${homeController.calories.value.burned ?? 0}",
                                              // maxLines: 1,
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26.sp,
                                              ),
                                            ),
                                            Text(
                                              "kcal",
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 14.w),

                                  Row(
                                    children: [
                                      Text(
                                        "${tr("eaten")}  ",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          //color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5.w,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      circleStats(
                                        value:
                                            "${homeController.macros.value.carbs?.consumed ?? 0.0}",
                                        subLabel:
                                            "/ ${homeController.macros.value.carbs?.target ?? 0.0} g",
                                        label: "Carbs",
                                        progress:
                                            ((homeController
                                                    .macros
                                                    .value
                                                    .carbs
                                                    ?.percentage ??
                                                0.0) /
                                            100),

                                        progressColor: Colors.red,
                                      ),
                                      circleStats(
                                        value:
                                            "${homeController.macros.value.protein?.consumed ?? 0.0}",
                                        subLabel:
                                            "/ ${homeController.macros.value.protein?.target ?? 0.0} g",
                                        label: "Protein",
                                        progress:
                                            ((homeController
                                                    .macros
                                                    .value
                                                    .protein
                                                    ?.percentage ??
                                                0.0) /
                                            100),
                                        progressColor: Colors.orange,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      circleStats(
                                        value:
                                            "${homeController.macros.value.fats?.consumed ?? 0.0}",
                                        subLabel:
                                            "/ ${homeController.macros.value.fats?.target ?? 0.0} g",
                                        label: "Fat",
                                        progress:
                                            ((homeController
                                                    .macros
                                                    .value
                                                    .fats
                                                    ?.percentage ??
                                                0.0) /
                                            100),
                                        progressColor: Colors.blue,
                                      ),
                                      circleStats(
                                        value:
                                            "${homeController.macros.value.fiber?.consumed ?? 0.0}",
                                        subLabel:
                                            "/ ${homeController.macros.value.fiber?.target ?? 0.0} g",
                                        label: "Fiber",
                                        progress:
                                            ((homeController
                                                    .macros
                                                    .value
                                                    .fiber
                                                    ?.percentage ??
                                                0.0) /
                                            100),
                                        progressColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      Text(
                                        "${tr("micronutrients")}  ",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          //color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5.w,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),

                                  Stack(
                                    children: [
                                      /*   Opacity(
                                        opacity: isPremium ? 1 : 0.4,
                                        child: */
                                        
                                      Column(
                                        children: [
                                          SizedBox(height: 10.h),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              microItem(
                                                "Fiber",
                                                homeController
                                                    .micronutrients
                                                    .value
                                                    .fiber,
                                              ),
                                              microItem(
                                                "Sodium",
                                                homeController
                                                    .micronutrients
                                                    .value
                                                    .sodium,
                                              ),
                                              microItem(
                                                "Potassium",
                                                homeController
                                                    .micronutrients
                                                    .value
                                                    .potassium,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              microItem(
                                                "Calcium",
                                                homeController
                                                    .micronutrients
                                                    .value
                                                    .calcium,
                                              ),
                                              microItem(
                                                "Iron",
                                                homeController
                                                    .micronutrients
                                                    .value
                                                    .iron,
                                              ),
                                              microItem(
                                                "Vitamin A",
                                                homeController
                                                    .micronutrients
                                                    .value
                                                    .vitaminA,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              microItem(
                                                "Vitamin C",
                                                homeController
                                                    .micronutrients
                                                    .value
                                                    .vitaminC,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // ),

                                      /* if (!isPremium)
                                        Positioned.fill(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(() => UpgradePlan());
                                            },

                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 6,
                                                  sigmaY: 6,
                                                ),
                                                child: Container(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.lock,
                                                        color: Colors.white,
                                                        size: 30.sp,
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        tr("premium_features"),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ), */
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      Text(
                                        "${tr("burned")}  ",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          //color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5.w,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              "👣 ${tr("walking")}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "${homeController.steps.value.caloriesBurned ?? 0}",
                                              style: TextStyle(
                                                // color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),

                                            SizedBox(height: 4.h),
                                            Text(
                                              "kcal",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              "💪  ${tr("activity")} ",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),

                                            Text(
                                              "${homeController.activity.value.caloriesBurned ?? 0}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30.sp,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "kcal",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await Get.to(() => ActivityScreen());
                                          await homeController.dashboardData(
                                            homeController.selectedDate.value,
                                          );
                                        },
                                        child: Container(
                                          height: 43.h,
                                          width: 43.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.secondary,
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),

                          /*    SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => UpgradePlan());
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Row(
                                children: [
                                  Center(
                                    child: /* SvgPicture.asset(
                                      "assets/icons/crown.svg",
                                      colorFilter: ColorFilter.mode(
                                        AppColors.secondary,
                                        BlendMode.srcIn,
                                      ),
                                      height: 25.w,
                                    ), */ Image.asset(
                                      "assets/images/crown_dotted.png",
                                      fit: BoxFit.cover,
                                      height: 40.w,
                                      width: 40.w,
                                    ),
                                  ),

                                  SizedBox(width: 10.w),

                                  Expanded(
                                    child: Text(
                                      tr("upgrade_plan"),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ), */

                          /*   Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.asset(
                                  "assets/images/new_arrival.jpg",
                                  width: 0.8.sw,
                                  height: 150.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 12.w,
                                left: 12.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "NEW ARRIVAL",
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "SPECIAL OFFER",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(
                                          4.w,
                                        ),
                                      ),
                                      child: Text(
                                        "50% OFF",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ), */
                          SizedBox(height: 10.h),
                          // progressContainer(),
                          Obx(
                            () => _mealTile(
                              tr("breakfast"),
                              "breakfast",
                              "${homeController.breakfast.value.consumed} / ${homeController.breakfast.value.required} kcal",
                              //'0 kcal',
                              // "assets/images/breakfast_image.jpeg",
                              "assets/images/image_1.png",
                              ((homeController.breakfast.value.percentage ??
                                      0.0) /
                                  100),
                            ),
                          ),
                          Obx(
                            () => _mealTile(
                              tr("lunch"),
                              "lunch",
                              "${homeController.lunch.value.consumed} / ${homeController.lunch.value.required} kcal",
                              //'0 kcal',
                              // "assets/images/lunch_image.jpeg",
                              "assets/images/image_2.png",
                              ((homeController.lunch.value.percentage ?? 0.0) /
                                  100),
                            ),
                          ),

                          Obx(
                            () => _mealTile(
                              tr("snacks"),
                              "snacks",
                              "${homeController.snacks.value.consumed} / ${homeController.snacks.value.required} kcal",
                              // '0 kcal',
                              "assets/images/image_3.png",
                              // "assets/images/snacks_image.jpeg",
                              ((homeController.snacks.value.percentage ?? 0.0) /
                                  100),
                            ),
                          ),
                          Obx(
                            () => _mealTile(
                              tr("dinner"),
                              "dinner",
                              "${homeController.dinner.value.consumed} / ${homeController.dinner.value.required} kcal",
                              //'0 kcal',
                              // "assets/images/dinner_image.jpeg",
                              "assets/images/image_4.png",
                              ((homeController.dinner.value.percentage ?? 0.0) /
                                  100),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => homeController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularLoader()),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  Widget microItem(String label, num? value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp)),
        SizedBox(height: 3.w),
        Text(
          (value ?? 0).toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ],
    );
  }

  Widget progressContainer() {
    return Container(
      width: 0.8.sw,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: AppColors.progress,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: AppColors.progressBorder, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            "Today progress",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _progressBox(
                  "assets/images/heart_rate.png",
                  "120",
                  "Heart Rate",
                  AppColors.heartRate,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _progressBox(
                  "assets/images/h2o.png",
                  "100",
                  "",
                  AppColors.h2o,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _progressBox(
                  "assets/images/foot.png",
                  "3,580",
                  "Steps",
                  AppColors.foot,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.w, right: 8.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: _progressBox(
                      "assets/images/sleeping.png",
                      "10h 29m",
                      "",
                      AppColors.sleeping,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressBox(
    String image,
    String title,
    String subtitle,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17.r,
            backgroundColor: color,
            child: Padding(
              padding: EdgeInsets.all(6.0.w),
              child: Image.asset(image),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealTile(
    String title,
    String mealType,
    String subtitle,
    String image,
    double value,
  ) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => MealsScreen(title: title, mealType: mealType));
        await homeController.dashboardData(homeController.selectedDate.value);
      },

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.w),
          decoration: BoxDecoration(
            // color: Color(0xffF5F5F5),
            // borderRadius: BorderRadius.circular(16),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1.w,
              ),
            ),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: ClipOval(
                    child: Image.asset(
                      image,
                      height: 50.w,
                      width: 50.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            //  color: AppColors.text,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        CircleAvatar(
                          radius: 10.w,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40.w,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            border: Border.all(color: Colors.black12, width: 1),
                          ),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(1000),
                            value: value,
                            minHeight: 8.h,
                            backgroundColor: AppColors.background,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),

                        SizedBox(width: 8.w), // spacing

                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            //color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.secondary,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget circleStat({
  required String value,
  required String label,
  String? subLabel,
}) {
  return Column(
    children: [
      Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 6.w),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              if (subLabel != null)
                Text(
                  subLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    //color: Colors.grey.shade600
                  ),
                ),
            ],
          ),
        ),
      ),
      SizedBox(height: 6.h),
      Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          // color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget circleStats({
  required String value,
  required String label,
  required String subLabel,
  required double progress,
  Color progressColor = Colors.green,
}) {
  print(progress);
  return Column(
    children: [
      SizedBox(
        width: 80.w,
        height: 80.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular progress
            SizedBox(
              width: 70.w,
              height: 70.w,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6.5.w,
                backgroundColor: Color(0xffececec),
                // backgroundColor: AppColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                strokeCap: StrokeCap.round,
              ),
            ),

            // Center text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // if (subLabel != null)
                Text("$subLabel", style: TextStyle(fontSize: 12.sp)),
              ],
            ),
          ],
        ),
      ),

      SizedBox(height: 6.h),

      Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
    ],
  );
}
