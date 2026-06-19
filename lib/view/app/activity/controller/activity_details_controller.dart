import 'dart:convert';

import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/activity/model/activity_details_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ActivityDetailsController extends GetxController {
  var isFav = false.obs;
  var isFavLoading = false.obs;
  var isLoading = false.obs;
  var activityDetails = ActivityDetails().obs;
  var selectedDate = DateTime.now();

  var selectedDuration = 5.0.obs;
  var calculatedCalories = 0.0.obs;

  Future<void> fetchDetails(activityId) async {
    print("fetchActivityDetails");
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        "${ApiUrls.activityDetails}$activityId",
      );
      final jsonResponse = jsonDecode(response.body);
      print("${ApiUrls.activityDetails}$activityId");
      if (response.statusCode == 200) {
        print(response.body);
        ActivityDetailsModel model = ActivityDetailsModel.fromJson(
          jsonResponse,
        );
        activityDetails.value = model.data!;
        isFav.value = model.data!.isFavorite!;
        final durations = List.generate(12, (i) => (i + 1) * 5);
        final defaultDuration = model.data!.defaultDurationMin ?? 5;

        selectedDuration.value = durations.contains(defaultDuration)
            ? defaultDuration.toDouble()
            : durations.first.toDouble();

        calculatedCalories.value =
            selectedDuration.value * (model.data!.caloriesPerMin ?? 0);

        calculatedCalories.value =
            selectedDuration.value * (model.data!.caloriesPerMin ?? 0);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateDuration(value) {
    selectedDuration.value = value.toDouble();

    final perMin = activityDetails.value.caloriesPerMin?.toDouble() ?? 0.0;

    calculatedCalories.value = value * perMin;
  }

  String apiDateFormat(DateTime date) {
    final DateTime finaldate = date;
    return "${finaldate.year.toString().padLeft(4, '0')}-"
        "${finaldate.month.toString().padLeft(2, '0')}-"
        "${finaldate.day.toString().padLeft(2, '0')}";
  }

  Future<bool> saveActivity(
    String workoutId,
    int duration, {
    String? activityId,
  }) async {
    var body =  activityId != null ?
    {
       "duration_minutes": duration,
    }:{
      "workout_id": workoutId,
      "duration_minutes": duration,
      "activity_date": apiDateFormat(selectedDate),
    };
    print(body);
    try {
      final response = activityId != null
          ? await ApiServices.postRequest(
              "${ApiUrls.activityDetails}$activityId",
              body: body,
            )
          : await ApiServices.postRequest(ApiUrls.saveActivity, body: body);

      //activityDetails
      print("API: ${activityId != null ? "Update" : "Save"}");
      print("API: ${activityId != null ? "${ApiUrls.activityDetails}$activityId" : ApiUrls.saveActivity}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        AppSnackBar.showSuccess(
          activityId != null
              ? "Activity updated successfully!"
              : "Activity added successfully!",
        );

        return true;
      } else{
        print(response.statusCode);
      }
      return false;
    } catch (e) {
      print(e.toString());
      debugPrint("Add favorite error: $e");
      return false;
    }
  }

  Future<bool> addToFavoriteActivity(String activityId) async {
    try {
      final response = await ApiServices.postRequest(
        '${ApiUrls.addFavoriteActivity}$activityId',
      );
      print("${ApiUrls.addFavoriteActivity}$activityId");

      if (response.statusCode == 200) {
        print(response.body);
        showSuccess("Added to favorites!");
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      debugPrint("Add favorite error: $e");
      return false;
    }
  }

  Future<bool> removeFromFavoriteActivity(String activityId) async {
    try {
      final response = await ApiServices.deleteRequest(
        '${ApiUrls.addFavoriteActivity}$activityId',
      );

      if (response.statusCode == 200) {
        print(response.body);
        showSuccess("Removed from favorites!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Remove favorite error: $e");
      return false;
    }
  }

  Future<void> toggleFavorite(String foodId) async {
    bool success = false;

    if (isFav.value) {
      success = await showBottomSheet(Get.context!, foodId);
    } else {
      success = await addToFavoriteActivity(foodId);
    }
    if (success) {
      isFav.toggle();
    }
  }

  void showSuccess(String message) {
    final context = Get.overlayContext;

    if (context == null) return;

    final overlay = Overlay.of(context);
    final mediaQuery = MediaQuery.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: mediaQuery.padding.top + 120.w,
          left: 16.w,
          right: 16.w,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 18.w),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<bool> showBottomSheet(BuildContext context, String foodId) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Theme.of(context).colorScheme.primary,
              border: Border(top: BorderSide(color: Colors.white, width: 1)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  tr("remove"),
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                const Divider(thickness: 0.5),

                const SizedBox(height: 24),

                // Message
                 Text(
                  tr("remove_activity_confirm"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    // color: Color(0xff1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),

                 Text(
                  tr("add_back_later"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    // color: Colors.grey
                  ),
                ),

                const SizedBox(height: 12),

                const Divider(thickness: 0.5),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
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
                            final success = await removeFromFavoriteActivity(
                              foodId,
                            );

                            Navigator.pop(context, success);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff34C759),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "${tr("yes")}, ${tr("remove")}",
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
