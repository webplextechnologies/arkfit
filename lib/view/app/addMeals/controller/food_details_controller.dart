import 'dart:convert';
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/addMeals/model/food_deatils_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FoodDetailsController extends GetxController {
  var isLoading = false.obs;
  var foodDetails = FoodDetails().obs;
  var isFav = false.obs;
  var foodController = TextEditingController();

    RxInt quantity = 1.obs;

  /// Base serving size (example: 100)
  RxDouble baseWeight = 0.0.obs;

  /// Unit (example: g)
  RxString unit = "".obs;

  /// Final total weight (example: 200g)
  RxDouble totalQuantity = 0.0.obs;

  double parseDouble(dynamic value) {
    return double.tryParse(value.toString()) ?? 0;
  }

void setInitialQuantity(String quantityString) {
  try {
    final total = double.tryParse(quantityString) ?? 1;

    if (baseWeight.value == 0) {
      baseWeight.value = 1;
    }

    quantity.value = (total / baseWeight.value).round();

    totalQuantity.value = quantity.value * baseWeight.value;

    foodController.text = totalQuantity.value.toStringAsFixed(0);

    print(
      "Total: $total | BaseWeight: ${baseWeight.value} | Qty: ${quantity.value}",
    );
  } catch (e) {
    print("Error parsing quantity: $e");
  }
}

  Future<void> fetchFoodDetails(foodId, {String? initialQuantity}) async {
    print("fetchFoodDetails");
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest("${ApiUrls.foods}$foodId");
      final jsonResponse = jsonDecode(response.body);
      print("${ApiUrls.foods}$foodId");

      if (response.statusCode == 200) {
        print(response.body);
        FoodDetailsModel model = FoodDetailsModel.fromJson(jsonResponse);
        foodDetails.value = model.data!;
        isFav.value = model.data!.isFavorite!;
        
         baseWeight.value =
            parseDouble(model.data!.servingSize);

        unit.value = model.data!.servingUnit ?? "g";

        if (initialQuantity != null) {
          setInitialQuantity(initialQuantity);
        } else {
          quantity.value = 1;

          totalQuantity.value =
              baseWeight.value * quantity.value;

          foodController.text =
              totalQuantity.value.toStringAsFixed(0);
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      AppSnackBar.showError("${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  double _parseMacro(String? value) {
    if (value == null) return 0;
    return double.tryParse(value) ?? 0;
  }

  Future<bool> saveMeal({
    required MealAction action,
    required String mealId,
    required String foodId,
    String? itemId,
    required String quantity,
  }) async {
    final body = {"food_id": foodId, "quantity": quantity};
    print(body);
    try {
      final response = action == MealAction.add
          ? await ApiServices.postRequest(
              "${ApiUrls.addMealItem}$mealId",
              body: body,
            )
          : await ApiServices.putRequest(
              "${ApiUrls.addMealItem}$mealId",
              body: body,
            );
      action == MealAction.add
          ? print("${ApiUrls.addMealItem}$mealId")
          : print("${ApiUrls.addMealItem}$mealId");
      final json = jsonDecode(response.body);
      print(action);
      print(response.body);

      if (json["status"] == true) {
        AppSnackBar.showSuccess(
          action == MealAction.add
              ? "Food added successfully!"
              : "Food updated successfully!",
        );
        return true;
        
      }
      String errorMessage =
        json["messages"]?["error"] ??
        json["message"] ??
        "Something went wrong";

    AppSnackBar.showError(errorMessage);

    return false;
     
    } catch (e) {
      debugPrint("Save meal error: $e");
      return false;
    }
  }

  var isFavLoading = false.obs;

  Future<bool> addToFavoriteFood(String foodId) async {
    try {
      final response = await ApiServices.postRequest(
        '${ApiUrls.favoriteFood}/$foodId',
      );
      print("${ApiUrls.favoriteFood}/$foodId");

      if (response.statusCode == 200) {
        print(response.body);
        showSuccess("Added to favorites!");
        return true;
      } else {
        print(response.body);
      }
      return false;
    } catch (e) {
      print(e.toString());
      debugPrint("Add favorite error: $e");
      return false;
    }
  }

  Future<bool> removeFromFavoriteFood(String foodId) async {
    try {
      final response = await ApiServices.deleteRequest(
        '${ApiUrls.favoriteFood}/$foodId',
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
      success = await addToFavoriteFood(foodId);
    }
    if (success) {
      isFav.toggle();
    }
  }

  
 void increment() {
    quantity.value++;

    totalQuantity.value =
        quantity.value * baseWeight.value;

    foodController.text =
        totalQuantity.value.toStringAsFixed(0);
  }

  /// Decrease quantity
  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;

      totalQuantity.value =
          quantity.value * baseWeight.value;

      foodController.text =
          totalQuantity.value.toStringAsFixed(0);
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
                  tr("remove_food_confirm"),
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
                            final success = await removeFromFavoriteFood(
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
