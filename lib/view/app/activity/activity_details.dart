import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/activity/controller/activity_details_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ActivityDetails extends StatefulWidget {
  final String workoutId;
  final String? activityId;
  final int? duration;

  const ActivityDetails({
    super.key,
    required this.workoutId,
    this.activityId,
    this.duration,
  });

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  bool isFav = false;
  late ActivityDetailsController activityDetailsController;

  @override
  void initState() {
    super.initState();

    activityDetailsController = Get.put(ActivityDetailsController());

    activityDetailsController.fetchDetails(widget.workoutId).then((_) {
      final durationList = List.generate(12, (i) => (i + 1) * 5);
      if (widget.activityId != null &&
          widget.duration != null &&
          durationList.contains(widget.duration)) {
        activityDetailsController.selectedDuration.value = widget.duration!
            .toDouble();
        activityDetailsController.updateDuration(widget.duration!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.activityId != null;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            actionsPadding: EdgeInsets.symmetric(horizontal: 20),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    activityDetailsController.toggleFavorite(widget.workoutId);
                  },
                  child: Obx(() {
                    if (activityDetailsController.isFavLoading.value) {
                      return SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: CircularProgressIndicator(strokeWidth: 2.w),
                      );
                    }

                    return activityDetailsController.isFav.value
                        ? SvgPicture.asset(
                            'assets/icons/like.svg',
                            height: 20.w,
                            width: 20.w,
                          )
                        : SvgPicture.asset(
                            'assets/icons/favorite.svg',
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).iconTheme.color!,
                              BlendMode.srcIn,
                            ),
                            height: 20.w,
                            width: 20.w,
                          );
                  }),
                ),
                SizedBox(width: 15),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  border: Border.all(color: Colors.white, width: 1.w),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      SizedBox(height: 15.w),

                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              activityDetailsController
                                  .activityDetails
                                  .value
                                  .image ??
                              '',
                          height: 100.w,
                          width: 100.w,
                          fit: BoxFit.cover,

                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              'assets/images/activity_image.jpeg',
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12),

                      // Title
                      Text(
                        textAlign: TextAlign.center,
                        activityDetailsController.activityDetails.value.name ??
                            '',
                        style: TextStyle(
                          fontSize: 24.sp,
                          //color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10.w),
                      activityDetailsController
                                  .activityDetails
                                  .value
                                  .description !=
                              ''
                          ? Text(
                              textAlign: TextAlign.center,
                              activityDetailsController
                                      .activityDetails
                                      .value
                                      .description ??
                                  '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : SizedBox(),

                      Divider(height: 28.w),

                      _NutritionRow(
                       tr("calories"),
                        "${activityDetailsController.calculatedCalories.value.toStringAsFixed(2)} kcal",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr("duration"),
                            style: TextStyle(
                              fontSize: 18.sp,
                              // color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          Obx(() {
                            final durationList = List.generate(
                              12,
                              (i) => (i + 1) * 5,
                            );
                            final selected = activityDetailsController
                                .selectedDuration
                                .value;

                            return DropdownButton(
                              value: durationList.contains(selected)
                                  ? selected
                                  : durationList.first.toInt(),

                              underline: const SizedBox(),

                              items: durationList.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    "$e min",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),

                              onChanged: (val) {
                                if (val != null) {
                                  activityDetailsController
                                      .selectedDuration
                                      .value = val
                                      .toDouble();
                                  activityDetailsController.updateDuration(val);
                                }
                              },
                            );
                          }),
                        ],
                      ),

                      SizedBox(height: 12.w),
                    ],
                  ),
                ),
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
              child: CustomButton(
                icon: isEdit ? null : Icons.add,
                title: isEdit ? tr('update') : tr('add'),
                onPressed: () async {
                  final success = await activityDetailsController.saveActivity(
                    widget.workoutId,
                    activityDetailsController.selectedDuration.value.toInt(),
                    activityId: widget.activityId,
                  );
                  if (success == true) {
                    Get.back(result: true);
                  }
                },
              ),
            ),
          ),
        ),

        Obx(
          () => activityDetailsController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularLoader()),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String title;
  final String value;

  const _NutritionRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              // color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              //color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
