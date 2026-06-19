import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:ark_fit_gym/view/app/addMeals/controller/food_details_controller.dart';
import 'package:ark_fit_gym/view/app/addMeals/screens/edit_food_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FoodDetailsScreen extends StatefulWidget {
  final String foodId;
  final String mealId;
  final String? mealItemId;
  final String? qunatity;
  const FoodDetailsScreen({
    super.key,
    required this.foodId,
    required this.mealId,
    this.mealItemId,
    this.qunatity,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late FoodDetailsController foodDetailsController;

  @override
  void initState() {
    foodDetailsController = Get.put(FoodDetailsController());

    foodDetailsController.fetchFoodDetails(
      widget.foodId,
      initialQuantity: widget.qunatity,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.mealItemId != null;
 final displayWeight =
        foodDetailsController.foodDetails.value.servingSize ?? 1 * foodDetailsController.quantity.value;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            actionsPadding: EdgeInsets.symmetric(horizontal: 20.w),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).iconTheme.color!,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /* GestureDetector(
                  onTap: () {
                    setState(() {
                      isFav = !isFav;
                    });
                  },
                  child: isFav
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
                        ),
                ),*/
                GestureDetector(
                  onTap: () async {
                    foodDetailsController.toggleFavorite(widget.foodId);
                  },
                  child: Obx(() {
                    if (foodDetailsController.isFavLoading.value) {
                      return SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: CircularProgressIndicator(strokeWidth: 2.w),
                      );
                    }

                    return foodDetailsController.isFav.value
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

                SizedBox(width: 12.w),
              /*   SvgPicture.asset(
                  'assets/icons/Delete.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.pink,
                    BlendMode.srcIn,
                  ),

                  height: 24.w,
                  width: 24.w,
                ), */
                SizedBox(width: 15.w),
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
                child: Obx(() {
                  final displayCalories = 
                       _parseMacro(
                        foodDetailsController.foodDetails.value.calories ?? "0",
                      ) *
                      foodDetailsController.quantity.value; 
                  final displayCarbs =
                       _parseMacro(
                        foodDetailsController.foodDetails.value.carbs ?? "0",
                      ) *
                      foodDetailsController.quantity.value; 
                  final displayProtein = 
                      _parseMacro(
                        foodDetailsController.foodDetails.value.protein ?? "0",
                      ) *
                      foodDetailsController.quantity.value;
                  final displayFat = 
                      _parseMacro(
                        foodDetailsController.foodDetails.value.fats ?? "0",
                      ) *
                      foodDetailsController.quantity.value;

                  final displayFiber = 
                      _parseMacro(
                        foodDetailsController.foodDetails.value.fiber ?? "0",
                      ) *
                      foodDetailsController.quantity.value;
                  var foodDetail = foodDetailsController.foodDetails.value;
                  return Column(
                    children: [
                      //Food Image
                      /*Image.asset(
                        'assets/images/break.png',
                        height: 100,
                        width: 100,
                      ),*/
                      SizedBox(height: 12.w),
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: foodDetail.image ?? '',
                          height: 100.w,
                          width: 100.w,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/food_image.jpeg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.w),

                      // Title
                      Text(
                        textAlign: TextAlign.center,
                        foodDetail.name ?? '',
                        style: TextStyle(
                          fontSize: 24.sp,
                          //color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Divider(height: 28.w),

                      // Calories + Macros
                      Row(
                        children: [
                          // Calories Circle
                          SizedBox(
                            height: 100.w,
                            width: 100.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 2.w,
                                    centerSpaceRadius: 38.w,
                                    sections: [
                                      PieChartSectionData(
                                        showTitle: false,
                                        value: displayProtein.toDouble(),
                                        radius: 10.r,
                                        color: Colors.orange,
                                      ),
                                      PieChartSectionData(
                                        showTitle: false,
                                        radius: 10.r,
                                        value: displayCarbs.toDouble(),
                                        color: Colors.red,

                                        // title: '20%',
                                      ),
                                      PieChartSectionData(
                                        showTitle: false,
                                        radius: 10.r,
                                        value: displayFat.toDouble(),
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                     
                                      displayCalories.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 32.sp,
                                        // color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "kcal",
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 16.w),

                          // Macros
                          Expanded(
                            child: Column(
                              children: [
                                _MacroRow(
                                  color: Colors.red,
                                  title: tr("carbs"),
                                  value: "${displayCarbs.toStringAsFixed(2)} g",
                                  // value: "48 (20.0%)",
                                ),
                                _MacroRow(
                                  color: Colors.orange,
                                  title: tr("protein"),
                                  value: "${displayProtein.toStringAsFixed(2)} g",

                                  //value: "84 (35.0%)",
                                ),
                                _MacroRow(
                                  color: Colors.blue,
                                  title: tr("fat"),
                                  value: "${displayFat.toStringAsFixed(2)} g",

                                  // value: "108 (45.0%)",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Divider(height: 20.w),

                      // Nutrition
                      _NutritionRow(tr("fiber"), "${displayFiber.toStringAsFixed(2)} g"),

                      SizedBox(height: 10.w),

                      Row(
                        children: [
                          Text(
                            '${tr("minerals")}   ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              //color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.w),

                      Column(
                        children: foodDetail.mineralsMap.entries.map((e) {
                          return _NutritionRow(
                            "${e.key}",
                            //"${e.key.toUpperCase()}",
                            "${e.value} ",
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 10.w),

                      Row(
                        children: [
                          Text(
                            '${tr("vitamins")}   ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              //color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.w),

                      Column(
                        children: foodDetail.vitaminsMap.entries.map((e) {
                          return _NutritionRow(
                            e.key.toUpperCase(),
                            "${e.value ?? '0'}",
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 20.w),
                    ],
                  );
                }),
              ),
            ),
          ),
         /*  bottomNavigationBar: SafeArea(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 30.w),
              decoration: BoxDecoration(
                color:
                    Theme.of(
                      context,
                    ).bottomNavigationBarTheme.backgroundColor ??
                    Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            tr("weight"),
                            style: TextStyle(
                              fontSize: 12.w,
                              fontWeight: FontWeight.w600,
                              // color: AppColors.textSecondary,
                            ),
                          ),

                          Obx(
                            () => Text(
                              " ${foodDetailsController.totalQuantity.value.toInt()} ${foodDetailsController.foodDetails.value.servingUnit ?? 'g'}",
                              style: TextStyle(
                                fontSize: 24.w,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
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
                                  // color: Colors.white,
                                  color: Theme.of(context).colorScheme.primary,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24.r),
                                  ),
                                ),
                                child: EditFoodSheet(
                                  controller:
                                      foodDetailsController.foodController,
                                  onSave: () {
                                    foodDetailsController.foodController.text =
                                        foodDetailsController
                                            .foodController
                                            .text;
                                    Get.back();
                                  }, units: foodDetailsController.foodDetails.value.availableUnits??[],
                                ),
                              ),
                            ),
                          );
                          // Show Edit Sheet
                        },
                        child: SvgPicture.asset(
                          'assets/icons/Edit.svg',
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).iconTheme.color!,
                            BlendMode.srcIn,
                          ),

                          height: 24.w,
                          width: 24.w,
                        ),
                      ),
                      Spacer(),

                      GestureDetector(
                        onTap: foodDetailsController.decrement,
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Theme.of(context).iconTheme.color!,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Obx(
                        () => Text(
                          foodDetailsController.quantity.value.toString(),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: foodDetailsController.increment,
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).iconTheme.color!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),

                  CustomButton(
                    icon: isEdit ? null : Icons.add,
                    title: isEdit ? " ${tr('update')}" : " ${tr('add')}",
                    onPressed: () async {
                      print(foodDetailsController.totalQuantity.value);
                      //final bool isEdit = widget.mealItemId != null;
                      final success = await foodDetailsController.saveMeal(
                        action: isEdit ? MealAction.update : MealAction.add,
                        mealId: widget.mealId,
                        foodId: widget.foodId,
                        itemId: widget.mealItemId,
                        /*  quantity:
                            "${foodDetailsController.baseWeight.value * foodDetailsController.quantity.value} "
                            "${foodDetailsController.unit.value}",*/
                        quantity:
                            "${foodDetailsController.totalQuantity.value.toInt()} ${foodDetailsController.foodDetails.value.servingUnit}",
                      );
                      if (success == true) {
                        Get.back(result: true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ), */
          bottomNavigationBar: SafeArea(
  child: Container(
    padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 30.w),
    decoration: BoxDecoration(
      color: Theme.of(context)
              .bottomNavigationBarTheme
              .backgroundColor ??
          Theme.of(context).colorScheme.surface,
      border: Border(
        top: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Weight + Controls Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// Weight Display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("weight"),
                  style: TextStyle(
                    fontSize: 12.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Obx(
                  () => Text(
                    "${foodDetailsController.totalQuantity.value.toInt()} "
                    "${foodDetailsController.unit.value}",
                    style: TextStyle(
                      fontSize: 24.w,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),

            /// Edit Button
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
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
                        color:
                            Theme.of(context).colorScheme.primary,
                        borderRadius:
                            BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                      ),
                      child: EditFoodSheet(
                        controller:
                            foodDetailsController.foodController,

                        units: foodDetailsController
                                .foodDetails
                                .value
                                .availableUnits ??
                            [],

                        /// FIXED SAVE LOGIC
                        onSave: () {
                          final input =
                              double.tryParse(
                            foodDetailsController
                                .foodController.text,
                          );

                          if (input != null &&
                              input > 0) {
                            final base =
                                foodDetailsController
                                    .baseWeight.value;

                            foodDetailsController
                                .quantity.value =
                                (input / base).round();

                            foodDetailsController
                                    .totalQuantity
                                    .value =
                                foodDetailsController
                                        .quantity.value *
                                    base;
                          }

                        //  Get.back();
                        },
                      ),
                    ),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/icons/Edit.svg',
                height: 24.w,
                width: 24.w,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            ),

            Spacer(),

            /// Minus Button
            GestureDetector(
              onTap:
                  foodDetailsController.decrement,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                  border: Border.all(
                    color: AppColors.primary,
                  ),
                ),
                child: Icon(
                  Icons.remove,
                  color: Theme.of(context)
                      .iconTheme
                      .color!,
                ),
              ),
            ),

            SizedBox(width: 10.w),

            /// Quantity Count
            Obx(
              () => Text(
                foodDetailsController
                    .quantity.value
                    .toString(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ),

            SizedBox(width: 10.w),

            /// Plus Button
            GestureDetector(
              onTap:
                  foodDetailsController.increment,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                  border: Border.all(
                    color: AppColors.primary,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Theme.of(context)
                      .iconTheme
                      .color!,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.w),

        CustomButton(
          icon: isEdit ? null : Icons.add,
          title: isEdit
              ? " ${tr('update')}"
              : " ${tr('add')}",
          onPressed: () async {
            final success =
                await foodDetailsController.saveMeal(
              action: isEdit
                  ? MealAction.update
                  : MealAction.add,
              mealId: widget.mealId,
              foodId: widget.foodId,
              itemId: widget.mealItemId,

              /// FINAL FIXED QUANTITY FORMAT
              quantity:
                  "${foodDetailsController.totalQuantity.value} "
                  "${foodDetailsController.unit.value}",
            );

            if (success) {
              Get.back(result: true);
            }
          },
        ),
      ],
    ),
  ),
),
        ),
        Obx(
          () => foodDetailsController.isLoading.value
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

double _parseMacro(String? value) {
  if (value == null) return 0;
  return double.tryParse(value.replaceAll('g', '').trim()) ?? 0;
}

class _MacroRow extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const _MacroRow({
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.w),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                // color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              // color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
      padding: EdgeInsets.symmetric(vertical: 4.w),
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
