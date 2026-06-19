import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/account/screen/setting_screen.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/water_tracker_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/water_tracker_history.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/add_water_sheet.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/calender.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/edit_water_goal.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/water_drop_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../common/app_colors.dart';
import '../../../common/app_text_style.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  double waterLevel = 0.2;
  double currentML = 0;
  double goalML = 2500;

  String getWeekDay(DateTime date) {
    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1];
  }

  List<CalendarDay> days = [];
  int selectedIndex = 0;

  final List<String> day = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  late WaterTrackerController waterTrackerController;

  @override
  void initState() {
    waterTrackerController = Get.put(WaterTrackerController());
    super.initState();

    generateDays();
  }

  void generateDays() {
    DateTime today = DateTime.now();

    days = List.generate(7, (index) {
      return CalendarDay(today.subtract(Duration(days: 6 - index)));
    });

    selectedIndex = 6; // today selected
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                tr("water_tracker"),
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              actions: [
                
                GestureDetector(
                  onTap: () => Get.to(()=>SettingScreen()),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0.w),
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
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 85.w,
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
                              width: 60.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
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
          
                                  SizedBox(height: 6.w),
          
                                  /// Date Circle
                                  CircleAvatar(
                                    radius: 22.r,
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
          
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.w),
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WaterDropFill(
                                level: waterTrackerController.waterLevel,
                                width: 200.0.w,
                                height: 250.0.w,
                              
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${waterTrackerController.consumedWater.value.toInt()}",
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    " ml",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      //color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
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
                                  child: EditWaterGoal(
                                    waterTrackerController: waterTrackerController,
                                  ),
                                ),
                              ),
                            );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${tr("daily_goal")} : ",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        //color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      "${waterTrackerController.targetWater.value.toInt()} ml ",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        //color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'assets/icons/Edit.svg',
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context).iconTheme.color!,
                                        BlendMode.srcIn,
                                      ),
                                          
                                      height: 15.w,
                                      width: 15.w,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          
                    _historyHeader(),
                    SizedBox(height: 20.w),
                    // _dateHeader("Yesterday, Dec 22, 2024"),
                    // SizedBox(height: 20.w),
                    // _historyItem(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
          
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0.w),
                        child: SvgPicture.asset(
                          'assets/icons/water.svg',
                          height: 10.w,
                          width: 10.w,
                        ),
                      ), // Image.asset("assets/icons/water.jpg"),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        height: 50.w,
          
                        child: ElevatedButton(
                          onPressed: () {
                            print("Add Water");
          
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
                                  child: AddWaterSheet(
                                    waterTrackerController: waterTrackerController,
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            tr("drink"),
                            // "Drink (200 mL)",
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
           Obx(
          () => waterTrackerController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularLoader()),
                )
              : SizedBox(),
        ),
        ],
      ),
    );
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
          child: Divider(thickness: 0.5, color: Theme.of(context).dividerColor),
        ),
      ],
    );
  }

  Widget _historyHeader() {
    return Row(
      children: [
        Text(
          tr("history"),
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WaterTrackerHistory(),
              ),
            );
          },
          child: Text(
            tr("view_history"),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.green,
            ),
          ),
        ),
        Icon(Icons.arrow_forward, color: Colors.green, size: 20.w),
      ],
    );
  }

  Widget _historyItem() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40.w,
            width: 40.w,
            decoration: const BoxDecoration(
              // color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/water.svg',
              height: 15.w,
              width: 15.w,
            ),
            // const Icon(Icons.water_drop, color: Colors.white),
          ),

          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Water",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  "12:30 PM",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "300 mL",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
          ),
          SizedBox(width: 8.w),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }

  /* Widget _weekSelector() {
    return Column(
      children: [
        // const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            bool isSelected = selectedIndex == index;
            double progress = (index + 1) / 7;

            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
              },
              child: Column(
                children: [
                  Text(days[index]),
                  const SizedBox(height: 6),

                  // Progress Ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 44,
                        width: 44,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.withOpacity(.15)
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          dates[index].toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }*/
}
