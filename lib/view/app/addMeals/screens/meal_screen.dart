import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/addMeals/controller/meal_controller.dart';
import 'package:ark_fit_gym/view/app/addMeals/model/meals_list_model.dart';
import 'package:ark_fit_gym/view/app/addMeals/screens/add_food_intake_screen.dart';
import 'package:ark_fit_gym/view/app/addMeals/screens/food_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MealsScreen extends StatefulWidget {
  final String title;
  final String mealType;
  const MealsScreen({super.key, required this.title, required this.mealType});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late MealController mealController;

  @override
  void initState() {
    mealController = Get.put(Get.put(MealController()));
    super.initState();
  }

  List<MealsList> get filteredMeals {
    return mealController.mealsList
        .where((meal) => meal.mealType!.toLowerCase() == widget.mealType)
        .toList();
  }

  int get totalCalories {
    return filteredMeals.fold(
      0,
      (sum, meal) => sum + int.parse(meal.totalCalories ?? "0"),
    );
  }

  int? get mealId =>
      filteredMeals.isEmpty ? null : int.tryParse(filteredMeals.first.id ?? "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (mealController.isLoading.value) {
          return Center(child: CircularLoader());
        }

        if (filteredMeals.isEmpty) {
          return Center(
            child: Text(
              textAlign: TextAlign.center,
              //"No ${widget.title} data found\nfor today",
              tr("no_data_today"),
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
                    "$totalCalories kcal",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),

              SizedBox(height: 20.w),
              Expanded(
                child: SlidableAutoCloseBehavior(
                  child: ListView.builder(
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return Column(
                        children: meal.items!.map((item) {
                          return GestureDetector(
                            onTap: () => Get.to(
                              () => FoodDetailsScreen(
                                foodId: item.foodId!,
                                mealId: "$mealId",
                                mealItemId: item.id,
                                qunatity: item.quantity,
                              ),
                            ),
                            child: _mealTile(
                              item.foodName?.isNotEmpty == true
                                  ? item.foodName!
                                  : "Food",
                              "${item.calories} kcal • ${item.quantity} ${item.servingUnit}",
                              "${item.foodImage}",
                              item.id!,
                              key: ValueKey(item.id),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: CustomButton(
            icon: Icons.add,
            title: " ${tr("add")}",
            /* onPressed: () async {
              if (mealId != null) {
                print(mealId);

                final result = await Get.to(
                  () => AddFoodIntakeScreen(
                    title: widget.title,
                    mealId: mealId!.toString(),
                  ),
                );

                print("result : ${result}");

                
                if (result == true) {
                  await mealController.fetchMeals();
                }
              } else {
                await mealController.createMeal(widget.title);
                await mealController.fetchMeals();
              }
            },*/
            onPressed: () async {
              if (mealId != null) {
                final result = await Get.to(
                  () => AddFoodIntakeScreen(
                    title: widget.title,
                    mealId: "$mealId",
                  ),
                );

                if (result == true) {
                  await mealController.fetchMeals();
                }
              } else {
                final newMealId = await mealController.createMeal(
                  widget.mealType,
                );

                if (newMealId != null) {
                  final result = await Get.to(
                    () => AddFoodIntakeScreen(
                      title: widget.title,
                      mealId: newMealId,
                    ),
                  );

                  if (result == true) {
                    await mealController.fetchMeals();
                  }
                }
              }
              await mealController.fetchMeals();
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
    String foodId, {
    required Key key,
  }) {
    return Slidable(
      key: key, // ✅ unique key injected
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            onPressed: (context) {
              showDeleteFoodBottomSheet(context, foodId);
            },
            backgroundColor: const Color(0xffFF5A5A),
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            child: Center(
              child: Icon(Icons.delete, size: 28.w, color: Colors.white),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.w),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: 60.w,
                  width: 60.w,
                  fit: BoxFit.contain,

                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),

                  errorWidget: (context, url, error) {
                    return Image.asset(
                      "assets/images/food_image.jpeg",
                      fit: BoxFit.contain,
                      height: 60.w,
                      width: 60.w,
                    );
                  },
                ),
              ),
              // Image.asset(
              //   image,
              //   height: 50.w,
              //   width: 60.w,
              //   fit: BoxFit.contain,
              // ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
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
              SvgPicture.asset(
                'assets/icons/arrow-right.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
                height: 20.w,
                width: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteFoodBottomSheet(BuildContext context, foodId) {
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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
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
                  tr("delete_food_log"),
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
                          onPressed: () {
                            Get.back();
                            mealController.removeFood(foodId);
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
}
