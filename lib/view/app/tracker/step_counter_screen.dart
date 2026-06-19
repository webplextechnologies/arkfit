import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/step_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/step_tracker_history.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/calender.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/delete_menu.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/tick_painter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/* class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
 }
 class _StepCounterScreenState extends State<StepCounterScreen> {

  var isPlay = false;
  String getWeekDay(DateTime date) {
    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];
  }
  List<CalendarDay> days = [];
  int selectedIndex = 0;
  int stepGoal = 2000;
  final List<String> day = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List<int> dates = [16, 17, 18, 19, 20, 21, 22];
  late StepController stepController;

  @override
  void initState() {
    super.initState();
    //stepController = Get.put(StepController());
    stepController = Get.find<StepController>();
    stepController.todayStepsSummary();
    stepController.fetchStepsHistory();
    generateDays();
  }

  void generateDays() {
    DateTime today = DateTime.now();

    days = List.generate(7, (index) {
      return CalendarDay(today.subtract(Duration(days: 6 - index)));
    });
    selectedIndex = 6;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Step Counter",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            actions: [
              GestureDetector(
                  onTap: () => Get.to(()=>SettingScreen()),
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: SvgPicture.asset(
                    'assets/icons/Setting.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                    height: 24.w,
                    width: 24.w,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            color: AppColors.background,
            backgroundColor: AppColors.background,
            elevation: 0,
            strokeWidth: 0.0,
            displacement: 0,
            onRefresh: () async {
              await stepController.todayStepsSummary();
              await stepController.fetchStepsHistory();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80.w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        bool isSelected = index == selectedIndex;
                        DateTime date = days[index].date;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 65.w,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.green
                                    : Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Day Name
                                Text(
                                  getWeekDay(date),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),

                                SizedBox(height: 6.h),

                                /// Date Circle
                                CircleAvatar(
                                  radius: 22.w,
                                  backgroundColor: isSelected
                                      ? Colors.green
                                      : Colors.white,
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 25.h),

                  Container(
                    height: Get.height * 0.35,
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,

                      border: Border.all(color: Colors.white, width: 1.w),
                      borderRadius: BorderRadius.circular(16.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10.r,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(220.w, 220.w),
                          painter: ArcTickPainter(
                            tickCount: 28,
                            radius: 72.r,
                            startAngle: 140,
                            sweepAngle: 260,
                          ),
                        ),

                        Obx(() {
                          final int steps = stepController.steps.value;
                          final double percent = (steps / stepGoal).clamp(
                            0.0,
                            1.0,
                          );

                          return CircularPercentIndicator(
                            radius: 100.r,
                            lineWidth: 17.r,
                            percent: percent,
                            arcType: ArcType.FULL,
                            startAngle: 140,
                            animation: true,
                            animationDuration: 1200,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.transparent,
                            arcBackgroundColor: Colors.grey.shade200,
                            progressColor: AppColors.secondary,

                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 40.h),

                                Text(
                                  "Steps",
                                  style: TextStyle(fontSize: 18.sp),
                                ),

                                SizedBox(height: 4.h),

                                Text(
                                  "$steps",
                                  style: TextStyle(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 4.h),

                                Text(
                                  stepController.status.value,
                                  style: TextStyle(fontSize: 16.sp),
                                ),

                                SizedBox(height: 3.h),

                                Text(
                                  "/ $stepGoal",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ],
                            ),
                          );
                        }),
                        Obx(
                          () => Positioned(
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: stepController.status.value == 'walking'
                                    ? Colors.transparent
                                    : AppColors.secondary,
                                // isPlay
                                //     ? AppColors.secondary
                                //     : Colors.transparent,
                                border: Border.all(color: AppColors.secondary),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6.w),
                              child: SvgPicture.asset(
                                // isPlay
                                //     ? "assets/icons/play_button.svg"
                                //     : "assets/icons/pause_button.svg",
                                stepController.status.value == 'walking'
                                    ? "assets/icons/pause_button.svg"
                                    : "assets/icons/play_button.svg",
                                colorFilter: ColorFilter.mode(
                                  stepController.status.value == 'walking'
                                      ? AppColors.secondary
                                      : Colors.white,

                                  //isPlay ? Colors.white : AppColors.secondary,
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

                  SizedBox(height: 25.h),

                  GestureDetector(
                    onTap: () => stepController.sendStepsToApi(
                      stepController.steps.value,
                    ),
                    child: _historyHeader(),
                  ),

                  SizedBox(height: 10.h),
                  // Obx(
                  //   () => _dateHeader(
                  //     "Today, ${DateFormat('MMMM d, yyyy').format(DateTime.parse(stepController.date.value))}",
                  //   ),
                  // ),
                  Obx(() {
                    String formattedDate = "Today";

                    if (stepController.date.value.isNotEmpty) {
                      formattedDate =
                          "Today, ${DateFormat('MMMM d, yyyy').format(DateTime.parse(stepController.date.value))}";
                    }

                    return _dateHeader(formattedDate);
                  }),

                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(color: Colors.white, width: 1.w),
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    ),
                    child: Obx(() {
                      if (stepController.stepHistoryList.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/footprints.svg',

                                height: 20.w,
                                width: 20.w,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "No Step History Yet",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Start walking to track your steps",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stepController.stepHistoryList.length,

                        itemBuilder: (context, index) {
                          return historyTile(
                            steps:
                                stepController.stepHistoryList[index].steps ??
                                "0",
                            time: formatTime(
                              stepController.stepHistoryList[index].createdAt ??
                                  "0",
                            ),
                            calories:
                                stepController
                                    .stepHistoryList[index]
                                    .caloriesBurned ??
                                "0",
                            km:
                                stepController.stepHistoryList[index].source ??
                                "0.0",
                            stepId:
                                stepController.stepHistoryList[index].id ?? '0',
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => stepController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularLoader()),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  Widget historyTile({
    required String steps,
    required String time,
    required String calories,
    required String km,
    required String stepId,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(Get.context!).dividerColor),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/footprints.svg',

            // colorFilter: const ColorFilter.mode(
            //   Colors.red,
            //   BlendMode.srcIn,
            // ),
            height: 20.w,
            width: 20.w,
          ),
          SizedBox(width: 10.w),

          Text(
            steps,
            style: TextStyle(
              fontSize: 18.sp,
              //color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),

          SvgPicture.asset(
            'assets/icons/Time Circle.svg',
            height: 20.w,
            width: 20.w,
          ),
          SizedBox(width: 4.w),
          Text(
            time,
            style: TextStyle(
              fontSize: 18.sp,
              // color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          SvgPicture.asset(
            'assets/icons/fire.svg',
            // colorFilter: const ColorFilter.mode(
            //   Colors.red,
            //   BlendMode.srcIn,
            // ),
            height: 20.w,
            width: 20.w,
          ),
          SizedBox(width: 4.w),
          Text(
            calories,
            style: TextStyle(
              fontSize: 18.sp,
              //color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),

          /* 

        SvgPicture.asset(
          'assets/icons/Location.svg',

          // colorFilter: const ColorFilter.mode(
          //   Colors.red,
          //   BlendMode.srcIn,
          // ),
          height: 20.w,
          width: 20.w,
        ),
        SizedBox(width: 4.w),
        Text(
          km,
          style: TextStyle(
            fontSize: 18.sp,
            // color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),*/
          SizedBox(width: 10.w),
          DeleteMenu(
            onDelete: () {
              print("Delete clicked");
              stepController.removeSteps(stepId);
            },
          ),
          // const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
 */
class StepCounterScreen extends StatefulWidget {
  final String stepGoal;
  const StepCounterScreen({super.key,required this.stepGoal});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  String getWeekDay(DateTime date) {
    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];
  }

  List<CalendarDay> days = [];
  int selectedIndex = 0;
  int stepGoal = 2000;

  late StepController stepController;

  @override
  void initState() {
    super.initState();
    stepController = Get.find<StepController>();
    stepController.fetchTodayStepsFromHealth();
    stepController.fetchStepsHistory();

    generateDays();
  }

  void generateDays() {
    DateTime today = DateTime.now();

    days = List.generate(7, (index) {
      return CalendarDay(today.subtract(Duration(days: 6 - index)));
    });

    selectedIndex = 6;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (stepController.isPermissionDenied.value) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(title:  Text(tr("step_counter")), centerTitle: true),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_walk_rounded,
                    size: 80.w,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Permission Required",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "ARKfit needs access to your physical activity and health data to track your steps.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () => stepController.initHealth(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: const Text(
                      "Grant Permission",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                tr("step_counter"),
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
            ),

            body: RefreshIndicator(
              onRefresh: () async {
                await stepController.fetchTodayStepsFromHealth();
                await stepController.fetchStepsHistory();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(15.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80.w,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          bool isSelected = index == selectedIndex;
                          DateTime date = days[index].date;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                print(date);
                                stepController.fetchStepsHistory(
                                  selectedDate: date,
                                );
                              });
                            },
                            child: Container(
                              width: 65.w,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.green
                                      : Theme.of(context).dividerColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /// Day Name
                                  Text(
                                    getWeekDay(date),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),

                                  SizedBox(height: 6.h),

                                  /// Date Circle
                                  CircleAvatar(
                                    radius: 22.w,
                                    backgroundColor: isSelected
                                        ? Colors.green
                                        : Colors.white,
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 25.w),

                    /// =======================
                    /// PROGRESS CARD
                    /// =======================
                    Container(
                      height: Get.height * 0.35,
                      width: double.infinity,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16.w),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(220.w, 220.w),
                            painter: ArcTickPainter(
                              tickCount: 28,
                              radius: 72.r,
                              startAngle: 140,
                              sweepAngle: 260,
                            ),
                          ),

                          Obx(() {
                            final steps = stepController.steps.value;
                            final percent = int.parse(widget.stepGoal) == 0
                                ? 0.0
                                : (steps / int.parse(widget.stepGoal)).clamp(0.0, 1.0);

                            return CircularPercentIndicator(
                              radius: 100.r,
                              lineWidth: 17.r,
                              percent: percent,
                              startAngle: 140,
                              animation: true,
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor: Colors.transparent,
                              arcType: ArcType.FULL,
                              arcBackgroundColor: Colors.grey.shade200,
                              progressColor: AppColors.secondary,

                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 40.h),

                                  Text(
                                    tr("steps"),
                                    style: TextStyle(fontSize: 18.sp),
                                  ),

                                  SizedBox(height: 4.h),

                                  Text(
                                    "$steps",
                                    style: TextStyle(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  /*  Text(
                                      "Synced with Health",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    
                                    SizedBox(height: 3.h), */
                                  Text("/ ${widget.stepGoal}"),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    SizedBox(height: 25.h),
                    _historyHeader(),
                    SizedBox(height: 10.w),
                    Obx(() {
                      String formattedDate = tr("today");

                      if (stepController.date.value.isNotEmpty) {
                        formattedDate =
                            " ${DateFormat('MMMM d, yyyy').format(DateTime.parse(stepController.date.value))}";
                      }

                      return _dateHeader(formattedDate);
                    }),

                    Obx(() {
                      if (stepController.stepHistoryList.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/footprints.svg',

                                height: 20.w,
                                width: 20.w,
                              ),
                              SizedBox(height: 10.w),
                              Text(
                                tr("no_steps_history"),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                tr("start_walking"),
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stepController.stepHistoryList.length,

                        itemBuilder: (context, index) {
                          return historyTile(
                            steps:
                                stepController.stepHistoryList[index].steps ??
                                "0",
                            time: formatTime(
                              stepController.stepHistoryList[index].createdAt ??
                                  "0",
                            ),
                            calories:
                                stepController
                                    .stepHistoryList[index]
                                    .caloriesBurned ??
                                "0",
                            km:
                                stepController.stepHistoryList[index].source ??
                                "0.0",
                            stepId:
                                stepController.stepHistoryList[index].id ?? '0',
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          /// =======================
          /// LOADER
          /// =======================
          if (stepController.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularLoader()),
            ),
        ],
      );
    });
  }

  Widget historyTile({
    required String steps,
    required String time,
    required String calories,
    required String km,
    required String stepId,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(Get.context!).dividerColor),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/footprints.svg',

            // colorFilter: const ColorFilter.mode(
            //   Colors.red,
            //   BlendMode.srcIn,
            // ),
            height: 20.w,
            width: 20.w,
          ),
          SizedBox(width: 10.w),

          Text(
            steps,
            style: TextStyle(
              fontSize: 18.sp,
              //color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),

          /*  SvgPicture.asset(
            'assets/icons/Time Circle.svg',
            height: 20.w,
            width: 20.w,
          ),
          SizedBox(width: 4.w),
          Text(
            time,
            style: TextStyle(
              fontSize: 18.sp,
              // color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(), */
          SvgPicture.asset(
            'assets/icons/fire.svg',
            // colorFilter: const ColorFilter.mode(
            //   Colors.red,
            //   BlendMode.srcIn,
            // ),
            height: 20.w,
            width: 20.w,
          ),
          SizedBox(width: 4.w),
          Text(
            calories,
            style: TextStyle(
              fontSize: 18.sp,
              //color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),

          /* 

        SvgPicture.asset(
          'assets/icons/Location.svg',

          // colorFilter: const ColorFilter.mode(
          //   Colors.red,
          //   BlendMode.srcIn,
          // ),
          height: 20.w,
          width: 20.w,
        ),
        SizedBox(width: 4.w),
        Text(
          km,
          style: TextStyle(
            fontSize: 18.sp,
            // color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),*/
          SizedBox(width: 10.w),
          DeleteMenu(
            onDelete: () {
              print("Delete clicked");
              stepController.removeSteps(stepId);
            },
          ),
          // const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}

Widget _historyHeader() {
  return Row(
    children: [
      Text(
        tr("history"),
        style: TextStyle(
          fontSize: 20.sp,
          //color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      Spacer(),
      GestureDetector(
        onTap: () => Get.to(() => StepTrackerHistory()),
        child: Text(
          tr("view_all"),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
      ),
      Icon(Icons.arrow_forward, color: AppColors.secondary, size: 20.w),
    ],
  );
}

String formatTime(String time) {
  if (time.isEmpty) return "";

  DateTime dt = DateTime.parse(time);

  return DateFormat("hh:mm a").format(dt);
}

Widget _dateHeader(String text) {
  return Row(
    children: [
      Text(
        '${text}   ',
        style: TextStyle(
          fontSize: 14.sp,
          //color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
      Expanded(
        child: Divider(
          thickness: 0.5.w,
          color: Theme.of(Get.context!).dividerColor,
        ),
      ),
    ],
  );
}
