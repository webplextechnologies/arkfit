import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/activity/activity_details.dart';
import 'package:ark_fit_gym/view/app/activity/add_activity_log_screen.dart';
import 'package:ark_fit_gym/view/app/activity/controller/activity_screen_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late ActivityScreenController activityController;

  @override
  void initState() {
    activityController = Get.put(ActivityScreenController());
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
          tr("activity"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (activityController.isLoading.value) {
          return Center(child: CircularLoader());
        }

        if (activityController.activityList.isEmpty) {
          return Center(
            child: Text(
              textAlign: TextAlign.center,
              tr("no_activity_today"),
              //"No activity found\nfor today",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr("total"),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "${activityController.totalCalorie.value} kcal",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              SlidableAutoCloseBehavior(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: activityController.activityList.length,
                  itemBuilder: (context, index) {
                    final activity = activityController.activityList[index];
                    return GestureDetector(
                      child: _mealTile(
                        activity.name ?? "",
                        "${activity.caloriesBurned} kcal • ${activity.durationMinutes} min",
                        "${activity.image}",
                        activity.id ?? '',
                        activity.workoutId ?? '',
                        0,
                        //int.parse(activity.durationMinutes ?? ''),
                        // key: ValueKey(item.id),
                      ),
                    );
                  },
                ),
              ),

              /*
              _mealTile(
                "Basketball",
                "218 kcal , 30 mins",
                "assets/images/basketball.png",
              ),
              _mealTile(
                "Baseball",
                "218 kcal , 30 mins",
                "assets/images/baseball.png",
              ),
              _mealTile(
                "Soccer",
                "218 kcal , 30 mins",
                "assets/images/soccer.png",
              ),
              _mealTile(
                "American Football",
                "218 kcal , 30 mins",
                "assets/images/american_football.png",
              ),
              _mealTile(
                "Softball",
                "218 kcal , 30 mins",
                "assets/images/softball.png",
              ),
              _mealTile(
                "Table Tennis",
                "218 kcal , 30 mins",
                "assets/images/tennis.png",
              ),
              _mealTile(
                "Volleyball",
                "218 kcal , 30 mins",
                "assets/images/volleyball.png",
              ),*/
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: CustomButton(
            icon: Icons.add,
            title: " ${tr('add')}",
            onPressed: () async {
              await Get.to(() => AddActivityLogScreen());
              await activityController.fetchActivities();
            },
          ),
        ),
      ),
    );
  }

  Widget _mealTile(
    String title,
    String subtitle,
    String image,
    String activityId,
    String workoutId,
    int duration,
  ) {
    return Slidable(
      key: ValueKey(title),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            onPressed: (context) {
              showDeleteBottomSheet(context, activityId);
            },
            backgroundColor: const Color(0xffFF5A5A),
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            child: Center(
              child: Icon(Icons.delete, size: 25.w, color: Colors.white),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          await Get.to(
            () => ActivityDetails(
              workoutId: workoutId,
              activityId: activityId,
              duration: duration,
            ),
          );
          // await Get.to(() => EditActivityScreen(), arguments: );
          await activityController.fetchActivities();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.w),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              //Image.asset(image, height: 50, width: 70, fit: BoxFit.contain),
              ClipOval(
                child: Image.network(
                  image,
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/activity_image.jpeg',
                      fit: BoxFit.contain,
                      width: 50.w,
                      height: 50.w,
                    );
                  },
                ),
              ),

              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${title}",

                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        // color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 4.w),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        // color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SvgPicture.asset(
                'assets/icons/arrow-right.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),

                height: 24.w,
                width: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteBottomSheet(BuildContext context, activityId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.w, 20.w, 24.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.w),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                SizedBox(height: 20.w),
                
                Text(
                  tr("delete"),
                  style: TextStyle(
                    color: Color(0xffFF5A5A),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 16.w),

                Divider(thickness: 0.5.w),

                SizedBox(height: 24.w),

                // Message
                Text(
                  tr("delete_activity"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    // color: Color(0xff1A1A1A),
                  ),
                ),

                SizedBox(height: 12.w),

                Text(
                  tr("cannot_undo"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp),
                ),

                SizedBox(height: 24.w),

                Divider(thickness: 0.5.w),

                SizedBox(height: 24.w),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.w,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(color: AppColors.primary),
                          ),
                          child: Text(
                            tr("cancel"),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SizedBox(
                        height: 50.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            activityController.deleteActivity(activityId);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff34C759),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "${tr('yes')}, ${tr("delete")}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
        );
      },
    );
  }
}
