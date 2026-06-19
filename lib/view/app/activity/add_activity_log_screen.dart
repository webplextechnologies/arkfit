import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/activity/activity_details.dart';
import 'package:ark_fit_gym/view/app/activity/controller/add_activity_controller.dart';
import 'package:ark_fit_gym/view/app/activity/create_activity_screen.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddActivityLogScreen extends StatefulWidget {
  const AddActivityLogScreen({super.key});

  @override
  State<AddActivityLogScreen> createState() => _AddActivityLogScreenState();
}

class _AddActivityLogScreenState extends State<AddActivityLogScreen> {
  var selectedTab = 0;
  late AddActivityController activityController;

  @override
  void initState() {
    activityController = Get.put(AddActivityController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
        ),
        centerTitle: true,
        title: Text(
          "${tr('activity_log')} ",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: Get.height * 0.315.w,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
              child: Column(
                children: [
                  CustomTextField(
                    controller: activityController.searchController,
                    onChanged: activityController.onSearchChanged,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).iconTheme.color!,
                    ),
                    hintText: tr("search"),
                    showFocusBorder: false,
                    suffixIcon: Transform.scale(
                      scale: 0.5,
                      child: SvgPicture.asset(
                        'assets/icons/Scan.svg',
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          //onTap: () => Get.to(()=>QuickLogScreen()),
                          child: logContainer(
                            tr("quick_log"),
                            "assets/icons/Quick Log Icon.svg",
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(() => CreateActivityScreen()),
                          child: logContainer(
                            tr("create_activity"),
                            "assets/icons/Create Food Icon.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.w),
                  _tabBar(),
                  SizedBox(height: 30.w),

                  Expanded(
                    child: SlidableAutoCloseBehavior(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.w,
                          horizontal: 10.w,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(color: Colors.white, width: 1.w),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                          ),
                          child: Obx(() {
                           /*  if (activityController.isLoading.value) {
                              return const Center(child: CircularLoader());
                            } */
                            if (activityController.searchActivity.isEmpty) {
                              return  Center(
                                child: Text(tr("no_activity_found")),
                              );
                            }

                            return ListView.builder(
                              itemCount:
                                  activityController.searchActivity.length,
                              itemBuilder: (context, index) {
                                final activity =
                                    activityController.searchActivity[index];
                                return _mealTile(
                                  activity.name ?? '',
                                  "${activity.caloriesPerMin ?? ''} kcal / min",
                                  activity.image ?? '',
                                  activity.id!,
                                  enableSlide:
                                      activityController.selectedTab.value != 0,
                                  onTap: () {
                                    activityController.addToRecentActivity(
                                      activity.id!,
                                    );

                                    Get.to(
                                      () => ActivityDetails(
                                        workoutId: activity.id!,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget _mealTile(
    String title,
    String subtitle,
    String image,
    String activityId,
  ) {
    return Slidable(
      key: ValueKey(title),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            onPressed: (context) {
              showBottomSheet(
                context,
                activityId,
                activityController.selectedTabTitle,
              );
            },
            backgroundColor: const Color(0xffFF5A5A),
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(6),
            child: Center(
              child: Icon(Icons.delete, size: 28, color: Colors.white),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => Get.to(() => ActivityDetails(activityId: activityId)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
              // Image.asset(image, height: 50, width: 70, fit: BoxFit.contain),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
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

              SvgPicture.asset(
                'assets/icons/arrow-right.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),

                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  } */
  Widget _mealTile(
    String title,
    String subtitle,
    String image,
    String activityId, {
    required VoidCallback onTap,
    bool enableSlide = true,
  }) {
    Widget content = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                image,
                width: 45.w,
                height: 45.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      'assets/images/activity_image.jpeg',
                      fit: BoxFit.contain,
                      width: 45.w,
                      height: 45.w,
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
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.w),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18.w),
          ],
        ),
      ),
    );

    if (!enableSlide) return content;

    // ✅ Slide enabled
    return Slidable(
      key: ValueKey(title),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            onPressed: (context) {
              showBottomSheet(
                context,
                activityId,
                activityController.selectedTabTitle,
              );
            },
            backgroundColor: const Color(0xffFF5A5A),
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            child: Icon(Icons.delete),
          ),
        ],
      ),
      child: content,
    );
  }

  Widget _tabBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabItem(tr('recent'), 0),
            _tabItem(tr('favorites'), 1),
            _tabItem(tr('personal'), 2),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final selected = activityController.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => activityController.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.w),
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Theme.of(context).iconTheme.color,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context, activityId, String title) {
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
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                 Text(
                  tr("delete"),
                  style: TextStyle(
                    color: Color(0xffFF5A5A),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                const Divider(thickness: 0.5),

                const SizedBox(height: 24),

                // Message
                Text(
                 tr("delete_activity"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    //color: Color(0xff1A1A1A),
                  ),
                ),

                const SizedBox(height: 12),

                 Text(
                  tr("cannot_undo"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 24),

                const Divider(thickness: 0.5),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.back();

                            if (title == "Recent") {
                              await activityController.removeRecentActivity(
                                activityId,
                              );
                            } else if (title == "Favorites") {
                              await activityController.removefavoriteActivity(
                                activityId,
                              );
                            } else if (title == "Personal") {
                              await activityController.removeCustomActivity(
                                activityId,
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff34C759),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "${tr('yes')}, ${tr('delete')}",
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

  Widget logContainer(String title, String image) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: AppColors.background, width: 1.w),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
            height: 18.w,
            width: 18.w,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                // color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
