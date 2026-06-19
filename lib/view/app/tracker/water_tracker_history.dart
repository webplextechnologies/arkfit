import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_date_picker.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/water_history_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WaterTrackerHistory extends StatefulWidget {
  const WaterTrackerHistory({super.key});

  @override
  State<WaterTrackerHistory> createState() => _WaterTrackerHistoryState();
}

class _WaterTrackerHistoryState extends State<WaterTrackerHistory> {
  late WaterHistoryController waterHistoryController;

  @override
  void initState() {
    waterHistoryController = Get.put(WaterHistoryController());
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
                tr("water_tracker_history"),
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    final date = await CustomDatePicker.pickDate(context);

                    if (date != null) {
                      waterHistoryController.selectedDate.value = date;
                      await waterHistoryController.fetchWaterHistory();
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
                      height: 24.w,
                      width: 24.w,
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
                            .format(waterHistoryController.selectedDate.value)),
                      ),
                          SizedBox(
                            height: 10.w,
                          ),
                    Obx(() {
                      if (waterHistoryController.waterHistoryList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.water_drop_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text(
                                tr("no_data_today"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    
                      return ListView.builder(
                        itemCount: waterHistoryController.waterHistoryList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _historyItem(
                          waterHistoryController.waterHistoryList[index].amountMl ??
                              '0',
                          DateFormat('MMMM d, yyyy').format(
                            DateTime.parse(
                              waterHistoryController
                                      .waterHistoryList[index]
                                      .logDate ??
                                  '',
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => waterHistoryController.isLoading.value
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
        child: Divider(
          thickness: 0.5.w,
          color: Theme.of(Get.context!).dividerColor,
        ),
      ),
    ],
  );
}


  Widget _historyItem(final String amount, final String date) {
    return Column(
      children: [
        SizedBox(height: 10.w),
        Container(
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
                      tr("water"),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      date,
                      //"12:30 PM",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$amount mL",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
              ),
              SizedBox(width: 8.w),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
      ],
    );
  }
}
