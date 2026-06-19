import 'package:ark_fit_gym/common/custom_date_picker.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/weight_history_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/delete_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeightTrackerHistory extends StatefulWidget {
  const WeightTrackerHistory({super.key});

  @override
  State<WeightTrackerHistory> createState() => _WeightTrackerHistoryState();
}

class _WeightTrackerHistoryState extends State<WeightTrackerHistory> {
  late WeightHistoryController weightHistoryController;

  @override
  void initState() {
    weightHistoryController = Get.put(WeightHistoryController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            tr("weight_tracker_history"),
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                final date = await CustomDatePicker.pickDate(context);

                if (date != null) {
                  weightHistoryController.selectedDate.value = date;
                  await weightHistoryController.fetchWeightHistory();
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
            padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
            child: Container(
              padding:  EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Obx(() {
                    if (weightHistoryController.weightHistoryList.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.w),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/weight_counter.svg',
                                colorFilter: ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.srcIn,
                                ),
                                height: 20.w,
                                width: 20.w,
                              ),
                              SizedBox(height: 10),
                              Text(
                                tr("no_weight_history"),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                tr("start_logging_weight"),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount:
                          weightHistoryController.weightHistoryList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) => _mealTile(
                        weightHistoryController
                                .weightHistoryList[index]
                                .weightKg ??
                            '',
                        DateFormat('MMMM d, yyyy').format(
                          DateTime.parse(
                            weightHistoryController
                                    .weightHistoryList[index]
                                    .logDate ??
                                '',
                          ),
                        ),
                        weightHistoryController.weightHistoryList[index].id!,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mealTile(String title, String subtitle, String weightId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
      decoration: BoxDecoration(
        // color: Colors.red,
        // borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${title} kg",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    // color: AppColors.text,
                  ),
                ),

                SizedBox(height: 4.h),
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
          ),

          /*  SizedBox(width: 15),
          CircleAvatar(
            radius: 7,
            backgroundColor: AppColors.primary,
            child: SvgPicture.asset(
              'assets/icons/arrow-down.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 24,
              width: 24,
            ),
          ),
          Text(
            " - 0.2 kg",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ), */
          SizedBox(width: 8.w),
          /*  EditDeleteMenu(
            onEdit: () {
              print("Edit clicked");
            },
            onDelete: () {
              print("Delete clicked");
            },
          ), */
          DeleteMenu(
            onDelete: () {
              print("Delete clicked");
              weightHistoryController.deleteweight(weightId);
            },
          ),
          //const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
