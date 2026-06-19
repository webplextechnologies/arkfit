import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/screen/setting_screen.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/tracker_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/weight_tracker_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/weight_tracker_history.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/delete_menu.dart';
import 'package:ark_fit_gym/view/app/tracker/widget/update_weight_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WeightTrackerScreen extends StatefulWidget {
  final String currentWeight;
  final String startingWeight;
  final String goalWeight;
  const WeightTrackerScreen({
    super.key,
    required this.currentWeight,
    required this.startingWeight,
    required this.goalWeight,
  });

  @override
  State<WeightTrackerScreen> createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  late WeightTrackerController weightTrackerController;

  @override
  void initState() {
    weightTrackerController = Get.put(WeightTrackerController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double startWeight = double.tryParse(widget.startingWeight) ?? 0;

    double goalWeight = double.tryParse(widget.goalWeight) ?? 0;

    double currentWeight = double.tryParse(widget.currentWeight) ?? 0;

    double progress = 0;

    if (startWeight > goalWeight) {
      progress = (startWeight - currentWeight) / (startWeight - goalWeight);
    } else {
      progress = (currentWeight - startWeight) / (goalWeight - startWeight);
    }

    progress = progress.clamp(0.0, 1.0);
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                tr("weight_tracker"),
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              actions: [
                GestureDetector(
                  onTap: () => Get.to(() => SettingScreen()),
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
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 20.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("current"),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            //color: AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.currentWeight}",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                //color: AppColors.textPrimary,
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
                            /*SizedBox(width: 15),
                            CircleAvatar(
                              radius: 7,
                              backgroundColor: AppColors.primary,
                              child: SvgPicture.asset(
                                'assets/icons/arrow-down.svg',
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
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
                            ),*/
                          ],
                        ),

                        SizedBox(height: 15),
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(1000),
                          minHeight: 20,
                          value: progress,
                          backgroundColor: AppColors.background,
                          color: AppColors.secondary,
                        ),

                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${tr("starting")}: ${widget.startingWeight} kg",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                //color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              "${tr("goal")}: ${widget.goalWeight} kg",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                //color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          title: tr("update"),
                          onPressed: () {
                            final controller = Get.find<TrackerController>();
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                                    initialWeight: widget.currentWeight,
                                    trackerController: controller,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: _historyHeader(),
                            ),
                            SizedBox(height: 10.w),
                            Obx(() {
                              if (weightTrackerController
                                  .weightHistoryList
                                  .isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.w),
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
                                );
                              }
                              return ListView.builder(
                                itemCount: weightTrackerController
                                    .weightHistoryList
                                    .length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) => _mealTile(
                                  weightTrackerController
                                          .weightHistoryList[index]
                                          .weightKg ??
                                      '',
                                  DateFormat('MMMM d, yyyy').format(
                                    DateTime.parse(
                                      weightTrackerController
                                              .weightHistoryList[index]
                                              .logDate ??
                                          '',
                                    ),
                                  ),
                                  weightTrackerController
                                      .weightHistoryList[index]
                                      .id!,
                                ),
                              );
                            }),
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
            () => weightTrackerController.isLoading.value
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

  Widget _historyHeader() {
    return Row(
      children: [
        Text(
          tr("history"),
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        Spacer(),
        GestureDetector(
          onTap: () => Get.to(() => WeightTrackerHistory()),
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

  Widget _mealTile(String title, String subtitle, String weightId) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.w),
      decoration: BoxDecoration(
        // color: Colors.white,
        // borderRadius: BorderRadius.circular(16),
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
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
                    //color: AppColors.text,
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
          SizedBox(width: 15.w),

          /* CircleAvatar(
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
          ),*/
          SizedBox(width: 8.w),
          DeleteMenu(
            onDelete: () {
              print("Delete clicked");
              weightTrackerController.deleteweight(weightId);
            },
          ),
          /*  EditDeleteMenu(
            onEdit: () {
              print("Edit clicked");
              showModalBottomSheet(
                backgroundColor: Colors.white,
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => EditWeightSheet(),
              );
            },
            onDelete: () {
              print("Delete clicked");
            },
          ), */
        ],
      ),
    );
  }
}
