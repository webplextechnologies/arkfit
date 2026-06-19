import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_date_picker.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/step_history_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/water_history_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/delete_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StepTrackerHistory extends StatefulWidget {
  const StepTrackerHistory({super.key});

  @override
  State<StepTrackerHistory> createState() => _StepTrackerHistoryState();
}

class _StepTrackerHistoryState extends State<StepTrackerHistory> {
  late StepHistoryController stepHistoryController;

  @override
  void initState() {
    stepHistoryController = Get.put(StepHistoryController());
    super.initState();
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
                tr("step_tracker_history"),
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    final date = await CustomDatePicker.pickDate(context);

                    if (date != null) {
                      stepHistoryController.selectedDate.value = date;
                      await stepHistoryController.fetchStepHistory();
                    }
                  },

                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
                child: Column(
                  children: [
                    Obx(
                     ()=> _dateHeader(DateFormat('MMMM dd, yyyy')
                          .format(stepHistoryController.selectedDate.value)),
                    ),
                        SizedBox(
                          height: 10.w,
                        ),
                    Obx(() {
                      if (stepHistoryController.stepHistoryList.isEmpty) {
                        return Center(
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
                        itemCount: stepHistoryController.stepHistoryList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => historyTile(
                          steps:
                              stepHistoryController.stepHistoryList[index].steps ??
                              "0",
                          time:
                              stepHistoryController.stepHistoryList[index].logDate ??
                              "0",
                          calories:
                              stepHistoryController
                                  .stepHistoryList[index]
                                  .caloriesBurned ??
                              "0",
                          km:
                              stepHistoryController.stepHistoryList[index].source ??
                              "0.0",
                              stepId: stepHistoryController.stepHistoryList[index].id??'0'
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => stepHistoryController.isLoading.value
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

        /* Spacer(),

        
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
        ),*/
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
            stepHistoryController.removeSteps(stepId);
          },
        ),
      ],
    ),
  );
}
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


