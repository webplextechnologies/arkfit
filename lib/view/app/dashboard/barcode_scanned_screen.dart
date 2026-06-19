import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/dashboard/controller/dashboard_controller.dart';
import 'package:ark_fit_gym/view/app/home/model/barcode_food_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BarcodeScannedScreen extends StatefulWidget {
  final BarcodeFood scannedFood;
  const BarcodeScannedScreen({super.key, required this.scannedFood});

  @override
  State<BarcodeScannedScreen> createState() => _BarcodeScannedScreenState();
}

class _BarcodeScannedScreenState extends State<BarcodeScannedScreen> {
  bool isFav = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final displayCalories =
        _parseMacro(widget.scannedFood.calories ?? "0") * quantity;
    final displayCarbs =
        _parseMacro(widget.scannedFood?.carbs ?? "0") * quantity;
    final displayProtein =
        _parseMacro(widget.scannedFood?.protein ?? "0") * quantity;
    final displayFat = _parseMacro(widget.scannedFood?.fats ?? "0") * quantity;
    final displayWeight =
        _parseMacro(widget.scannedFood.servingSize ?? "0") * quantity;
   final displayFiber =
        _parseMacro(widget.scannedFood.fiber ?? "0");

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
            Get.find<DashboardController>().changeTab(0);
          },
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color!),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isFav = !isFav;
                });
              },
              child: isFav
                  ? SvgPicture.asset(
                      'assets/icons/like.svg',

                      height: 20,
                      width: 20,
                    )
                  : SvgPicture.asset(
                      'assets/icons/favorite.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                      height: 20,
                      width: 20,
                    ),
            ),

            SizedBox(width: 15),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                SizedBox(height: 12.w),

                /// Food Image
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.scannedFood.image ?? '',
                    height: 90.w,
                    width: 90.w,
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

                /// Food Name
                Text(
                  textAlign: TextAlign.center,
                  widget.scannedFood.name ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Divider(height: 28.w),
                Row(
                  children: [
                    SizedBox(
                      height: 110.w,
                      width: 110.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2.w,
                              centerSpaceRadius: 40.w,
                              sections: [
                                PieChartSectionData(
                                  // value: 35,
                                  showTitle: false,
                                  value: displayProtein,
                                  radius: 10.r,
                                  color: Colors.orange,
                                  // title: '35%',
                                  titleStyle: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                PieChartSectionData(
                                  showTitle: false,
                                  radius: 10.r,
                                  value: displayCarbs.toDouble(),
                                  color: Colors.red,
                                  // title: '20%',
                                  titleStyle: TextStyle(
                                    //color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                PieChartSectionData(
                                  showTitle: false,
                                  radius: 10.r,
                                  value: displayFat.toDouble(),
                                  color: Colors.blue,
                                  // title: '45%',
                                  titleStyle: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
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
                                  fontSize: 30.sp,
                                  //  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("kcal", style: TextStyle(fontSize: 12.sp)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 16.w),

                    Expanded(
                      child: Column(
                        children: [
                          _MacroRow(
                            color: Colors.red,
                            title: tr("carbs"),
                            value: displayCarbs.toStringAsFixed(1),
                          ),
                          _MacroRow(
                            color: Colors.orange,
                            title: tr("protein"),
                            value: displayProtein.toStringAsFixed(1),
                          ),
                          _MacroRow(
                            color: Colors.blue,
                            title: tr("fat"),
                            value: displayFat.toStringAsFixed(1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 20.w),
                _NutritionRow(
                  tr("fiber"),
                  "$displayFiber g",
                ),
                SizedBox(height: 10.w),
                 _NutritionRow(
                  'Sugar',
                  "${widget.scannedFood.sugar ?? '0'} g",
                ),
                SizedBox(height: 10.w),
                  _NutritionRow(
                  'SaturatedFat',
                  "${widget.scannedFood.saturatedFat ?? '0'} g",
                ),
                SizedBox(height: 10.w),
                  _NutritionRow(
                  'Cholesterol',
                  "${widget.scannedFood.cholesterol ?? '0'} g",
                ),
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
                  children: widget.scannedFood.mineralsMap.entries.map((e) {
                    return _NutritionRow(
                      "${e.key}",
                      //"${e.key.toUpperCase()}",
                      "${e.value.toStringAsFixed(2)} ",
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
                  children: widget.scannedFood.vitaminsMap.entries.map((e) {
                    return _NutritionRow(
                      e.key.toUpperCase(),
                      "${e.value?.toStringAsFixed(2) ?? '0'}",
                    );
                  }).toList(),
                ),

                SizedBox(height: 20.w),
              ],
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
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          //color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        "${displayWeight} g ",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/icons/Edit.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!,
                      BlendMode.srcIn,
                    ),

                    height: 24.sp,
                    width: 24.sp,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },

                    child: Container(
                      width: 43.w,
                      height: 43.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Icon(Icons.remove),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "$quantity",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      setState(() => quantity++);
                    },
                    child: Container(
                      width: 43.w,
                      height: 43.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              CustomButton(
                icon: Icons.add,
                title: " ${tr('add')}",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
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
      padding: EdgeInsets.symmetric(vertical: 6.w),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                //  color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            "$value g",
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

class _NutritionRow extends StatelessWidget {
  final String title;
  final String value;

  const _NutritionRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              //color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
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
