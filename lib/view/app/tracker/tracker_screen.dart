import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/tracker_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/step_counter_screen.dart';
import 'package:ark_fit_gym/view/app/tracker/water_tracker_screen.dart';
import 'package:ark_fit_gym/view/app/tracker/weight_tracker_screen.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/edit_bmi_sheet.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/tick_painter.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/update_weight_sheet.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/water_drop_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  double waterLevel = 0.2;
  late TrackerController trackerController;

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    trackerController = Get.put(TrackerController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/icons/icon.png",
                color: Theme.of(context).iconTheme.color!,
              ),
              Text(
                tr('tracker'),
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                //Theme.of(context).appBarTheme.titleTextStyle
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            ],
          ),
          // title: Text("Tracker", style: AppTextStyles.appbarTitle),
          // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        ),

        body: RefreshIndicator(
          color: Theme.of(context).iconTheme.color,
          onRefresh: () async {
            await trackerController.loadAllData(showLoader: false);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Get.to(() => WaterTrackerScreen());
                      await trackerController.todayWaterSummary();
                    },

                    child: waterContainer(),
                  ),
                  SizedBox(height: 15.h),
                  //StepCounterScreen
                  GestureDetector(
                    onTap: () async {
                      await Get.to(
                        () => StepCounterScreen(
                          stepGoal:
                              trackerController
                                  .onboardingData
                                  .value
                                  .profile
                                  ?.stepGoal ??
                              '0',
                        ),
                      );
                      await trackerController.todayStepsSummary();
                    },
                    child: stepsContainer(),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () => Get.to(
                      () => WeightTrackerScreen(
                        currentWeight:
                            trackerController.currentWeight.value.weightKg ??
                            '0',
                        startingWeight:
                            trackerController
                                .onboardingData
                                .value
                                .profile
                                ?.weightKg ??
                            '0',
                        goalWeight:
                            trackerController
                                .onboardingData
                                .value
                                .profile
                                ?.targetWeightKg ??
                            '0',
                      ),
                    ),
                    child: weightContainer(),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24.r),
                          ),
                        ),
                        builder: (_) => SafeArea(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              12.w,
                              20.w,
                              24.w,
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              color: Theme.of(context).colorScheme.primary,
                              border: Border(
                                top: BorderSide(color: Colors.white, width: 1),
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24.r),
                              ),
                            ),
                            child: EditBMIBottomSheet(
                              initialHeight:
                                  trackerController.currentBmi.value.heightCm ??
                                  '0',
                              initialWeight:
                                  trackerController
                                      .currentWeight
                                      .value
                                      .weightKg ??
                                  '0',
                              trackerController: trackerController,
                            ),
                          ),
                        ),
                      );
                    },
                    child: bgmiContainer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget waterContainer() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 30.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: Colors.white, width: 1.w),
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        child: Row(
          children: [
            /// LEFT SIDE TEXT
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("water"),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Row(
                  children: [
                    Text(
                      "${trackerController.consumedWater.value.toInt()}",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(" ml", style: TextStyle(fontSize: 16.sp)),
                  ],
                ),

                Text(
                  "/ ${trackerController.targetWater.value.toInt()} mL",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),

            Spacer(),

            GestureDetector(
              onTap: () async {
                trackerController.consumedWater.value -= 250;
                if (trackerController.consumedWater.value < 0) {
                  trackerController.consumedWater.value = 0;
                }
                await _player.setVolume(0.01);
                await _player.play(AssetSource('sounds/water_sound.mp3'));
              },
              child: _circleButton(Icons.remove),
            ),

            SizedBox(width: 10.w),

            /// WATER DROP
            WaterDropFill(
              level: trackerController.waterLevel,
              width: 75.0.w,
              height: 96.0.w,
            ),

            SizedBox(width: 10.w),

            /// ADD BUTTON
            GestureDetector(
              onTap: () async {
                trackerController.consumedWater.value += 250;
                if (trackerController.consumedWater.value >
                    trackerController.targetWater.value) {
                  trackerController.consumedWater.value =
                      trackerController.targetWater.value;
                }
                // await _player.setVolume(0.5);
                await _player.play(AssetSource('sounds/water_sound.mp3'));
                await trackerController.updateWaterIntake();
              },
              child: _circleButton(Icons.add),
            ),
          ],
        ),
      );
    });
  }

  Widget _circleButton(IconData icon) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.lightBlueAccent),
      ),
      child: Icon(icon),
    );
  }

  Widget stepsContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 30.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr("steps"),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    // color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        "${trackerController.steps.value}",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          //color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      " ${tr("steps")}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        // color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Text(
                    "/ ${trackerController.onboardingData.value.profile?.stepGoal ?? '0'} ${tr("steps")}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      //color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(120, 120),
                painter: ArcTickPainter(
                  tickCount: 20,
                  radius: 40,
                  startAngle: 130,
                  sweepAngle: 275,
                ),
              ),
              Obx(() {
                double percent =
                    (trackerController.steps.value /
                            int.parse(
                              trackerController
                                      .onboardingData
                                      .value
                                      .profile
                                      ?.stepGoal ??
                                  '0',
                            ))
                        .clamp(0.0, 1.0);
                return CircularPercentIndicator(
                  radius: 65.r,
                  lineWidth: 13.w,
                  percent: percent,
                  arcType: ArcType.FULL,
                  startAngle: 140,
                  animation: true,
                  animationDuration: 1200,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                  arcBackgroundColor: Colors.grey.shade200,
                  progressColor: AppColors.secondary,
                  center: Container(
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.w,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          //SpeedometerWidget(),
        ],
      ),
    );
  }

  Widget weightContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 30.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr("weight"),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    // color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        trackerController.currentWeight.value.weightKg ?? '0',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          // color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      " kg",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        //color: AppColors.textPrimary,
                      ),
                    ),
                    /*SizedBox(width: 15.w),
                      CircleAvatar(
                        radius: 7.w,
                        backgroundColor: AppColors.primary,
                        child: SvgPicture.asset(
                          'assets/icons/arrow-down.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          height: 24.w,
                          width: 24.w,
                        ),
                      ),
                      Text(
                        " - 0.2 kg",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),*/
                    Spacer(),
                    SizedBox(
                      height: 40.w,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24.r),
                              ),
                            ),
                            builder: (_) => SafeArea(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  12.w,
                                  20.w,
                                  24.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white,
                                      width: 1.w,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24.r),
                                  ),
                                ),
                                child: UpdateWeightSheet(
                                  initialWeight:
                                      trackerController
                                          .currentWeight
                                          .value
                                          .weightKg ??
                                      "0",
                                  trackerController: trackerController,
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(tr('update'), style: AppTextStyles.button),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                //  LinearProgressIndicator(
                //     borderRadius: BorderRadius.circular(1000.r),
                //     minHeight: 20.w,
                //     value: progress,
                //     backgroundColor: AppColors.background,
                //     color: AppColors.secondary,
                //   ),
                Obx(() {
                  double startWeight =
                      double.tryParse(
                        trackerController
                                .onboardingData
                                .value
                                .profile
                                ?.weightKg ??
                            "0",
                      ) ??
                      0;

                  double goalWeight =
                      double.tryParse(
                        trackerController
                                .onboardingData
                                .value
                                .profile
                                ?.targetWeightKg ??
                            "0",
                      ) ??
                      0;

                  double currentWeight =
                      double.tryParse(
                        trackerController.currentWeight.value.weightKg ?? "0",
                      ) ??
                      0;

                  double progress = 0;

                  if (startWeight > goalWeight) {
                    progress =
                        (startWeight - currentWeight) /
                        (startWeight - goalWeight);
                  } else {
                    progress =
                        (currentWeight - startWeight) /
                        (goalWeight - startWeight);
                  }

                  progress = progress.clamp(0.0, 1.0);

                  return LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(1000.r),
                    minHeight: 20.w,
                    value: progress,
                    backgroundColor: AppColors.background,
                    color: AppColors.secondary,
                  );
                }),

                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        "${tr("starting")} : ${trackerController.onboardingData.value.profile?.weightKg ?? ''} kg",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          //color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        "${tr("goal")} : ${trackerController.onboardingData.value.profile?.targetWeightKg ?? ''} kg",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          // color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bgmiContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 30.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            tr("bmi"),
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Obx(() {
                double bmi =
                    double.tryParse(
                      trackerController.currentBmi.value.bmi ?? "0",
                    ) ??
                    0;

                return Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),

              SizedBox(width: 8.w),

              Obx(() {
                double bmi =
                    double.tryParse(
                      trackerController.currentBmi.value.bmi ?? "0",
                    ) ??
                    0;
                return Text(
                  getBmiStatus(bmi),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                );
              }),

              Spacer(),

              /// EDIT BUTTON
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xffEEEEEE)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(
                    'assets/icons/Edit.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                    height: 24.w,
                    width: 24.w,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          /// BMI BAR + INDICATOR
          Obx(() {
            double bmi =
                double.tryParse(
                  trackerController.currentBmi.value.bmi ?? "0",
                ) ??
                0;

            /// convert BMI into position
            double position = getBmiPosition(bmi).clamp(0.0, 1.0);

            return LayoutBuilder(
              builder: (context, constraints) {
                //  double indicatorPosition = constraints.maxWidth * position;
                double indicatorPosition = (constraints.maxWidth * position)
                    .clamp(10, constraints.maxWidth - 10);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    /// COLORED BMI BARS
                    Row(
                      children: [
                        _bmiBar(Colors.indigo, bmi, 0),
                        _bmiBar(Colors.blue, bmi, 1),
                        _bmiBar(Colors.green, bmi, 2),
                        _bmiBar(Colors.yellow, bmi, 3),
                        _bmiBar(Colors.orange, bmi, 4),
                        _bmiBar(Colors.deepOrange, bmi, 5),
                        _bmiBar(Colors.red, bmi, 6),
                      ],
                    ),

                    /// TRIANGLE INDICATOR
                  ],
                );
              },
            );
          }),

          Text(
            'Source: Ministry of Health Jamaica',
            style: TextStyle(fontSize: 14.sp),
          ),

          GestureDetector(
            onTap: () {
              /*Get.to(
                () => WebViewScreen(
                  url:
                      'https://ncdip.moh.gov.jm/know-your-numbers/body-mass-index-bmi-waist-circumference/',
                  title: 'BMI Source',
                ),
              ); */
              trackerController.openBMIReference();
            },
            child: Text(
              'View BMI Reference',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _bmiBar(Color color, double bmi, int index) {
    int activeIndex = getBmiIndex(bmi);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10.w,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          if (index == activeIndex)
            // Icon(Icons.arrow_drop_up, size: 30.w, color: color)
            Transform.translate(
              offset: Offset(0, -10.w),
              child: Icon(Icons.arrow_drop_up, size: 30.w, color: color),
            )
          else
            SizedBox(height: 28.w),
        ],
      ),
    );
  }

  /// BMI STATUS FUNCTION
  String getBmiStatus(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi < 25) {
      return "Normal";
    } else if (bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  Color getBmiIndicatorColor(double bmi) {
    if (bmi < 16) return Colors.indigo;
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 27.5) return Colors.yellow;
    if (bmi < 30) return Colors.orange;
    if (bmi < 35) return Colors.deepOrange;
    return Colors.red;
  }

  double getBmiPosition(double bmi) {
    if (bmi <= 16) return (bmi / 16) * (1 / 7);
    if (bmi <= 18.5) return (1 / 7) + ((bmi - 16) / (18.5 - 16)) * (1 / 7);
    if (bmi <= 25) return (2 / 7) + ((bmi - 18.5) / (25 - 18.5)) * (1 / 7);
    if (bmi <= 27.5) return (3 / 7) + ((bmi - 25) / (27.5 - 25)) * (1 / 7);
    if (bmi <= 30) return (4 / 7) + ((bmi - 27.5) / (30 - 27.5)) * (1 / 7);
    if (bmi <= 35) return (5 / 7) + ((bmi - 30) / (35 - 30)) * (1 / 7);

    return 6 / 7 + ((bmi - 35) / 10) * (1 / 7);
  }

  int getBmiIndex(double bmi) {
    if (bmi < 16) return 0;
    if (bmi < 18.5) return 1;
    if (bmi < 25) return 2;
    if (bmi < 27.5) return 3;
    if (bmi < 30) return 4;
    if (bmi < 35) return 5;
    return 6;
  }
}
