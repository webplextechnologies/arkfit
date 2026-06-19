import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/addMeals/controller/food_intake_controller.dart';
import 'package:ark_fit_gym/view/app/addMeals/screens/create_food_screen.dart';
import 'package:ark_fit_gym/view/app/addMeals/screens/food_details.dart';
import 'package:ark_fit_gym/view/app/addMeals/screens/quick_log_screen.dart';
import 'package:ark_fit_gym/view/app/dashboard/scanner_screen.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddFoodIntakeScreen extends StatefulWidget {
  final String title;
  final String mealId;

  const AddFoodIntakeScreen({
    super.key,
    required this.title,
    required this.mealId,
  });

  @override
  State<AddFoodIntakeScreen> createState() => _AddFoodIntakeScreenState();
}

class _AddFoodIntakeScreenState extends State<AddFoodIntakeScreen> {
  var isSlected = false;
  late FoodIntakeController foodIntakeController;

  @override
  void initState() {
    foodIntakeController = Get.put(FoodIntakeController());
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
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color!),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.title} ",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SvgPicture.asset(
              'assets/icons/arrow-down.svg',
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: Get.height * 0.37,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
              child: Column(
                children: [
                  CustomTextField(
                    controller: foodIntakeController.searchController,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    onChanged: foodIntakeController.onSearchChanged,
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
                      /*    Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(() => QuickLogScreen()),
                          child: logContainer(
                            "  ${tr('quick_log')}",
                            "assets/icons/Quick Log Icon.svg",
                           
                          ),
                        ),
                      ), */
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>  Get.to (() => ScannerScreen()),
                           //onTap: () => Get.to(() => QuickLogScreen()),
                          child: logContainer(
                            tr('scan_barcode'),
                            "assets/icons/Scan.svg",
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(() => CreateFoodScreen()),
                          child: logContainer(
                            " ${tr('create_food')}",
                            "assets/icons/Create Food Icon.svg",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Obx(() => _tabBar()),
                  SizedBox(height: 40.w),

                  Expanded(
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
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                        ),
                        child: Obx(() {
                          /*   if (foodIntakeController.isLoading.value) {
                            return const Center(child: CircularLoader());
                          } */
                          if (foodIntakeController.foodList.isEmpty) {
                            return Center(child: Text(tr("no_food_found")));
                          }

                          return ListView.builder(
                            itemCount: foodIntakeController.foodList.length,
                            itemBuilder: (context, index) {
                              final food = foodIntakeController.foodList[index];
                              return GestureDetector(
                                onTap: () async {
                                  foodIntakeController.addToRecentFood(
                                    food.id!,
                                  );
                                  final result = await Get.to(
                                    () => FoodDetailsScreen(
                                      foodId: food.id!,
                                      mealId: widget.mealId,
                                    ),
                                  );

                                  print("AddFoodIntake result: $result");
                                  if (result == true) {
                                    Get.back(result: true);
                                  }
                                },
                                child: _mealTile(
                                  food.name ?? '',
                                  food.description ?? '',
                                  food.image ?? '',
                                ),
                              );
                            },
                          );
                        }),
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

  Widget _mealTile(String title, String description, String image) {
    return Slidable(
      key: ValueKey(title),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,

        children: [
          CustomSlidableAction(
            onPressed: (context) {
              showDeleteFoodBottomSheet(context);
            },
            backgroundColor: const Color(0xffFF5A5A),
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(6),
            child: Center(
              child: Icon(Icons.delete, size: 28.w, color: Colors.white),
            ),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 14.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          //borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Image.network(
                image,
                width: 45.w,
                height: 45.w,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/food_image.jpeg",
                    fit: BoxFit.contain,
                    width: 45.w,
                    height: 45.w,
                  );
                },
              ),
            ),

            // Image.asset(image, height: 50, width: 70, fit: BoxFit.contain),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      //color: AppColors.text,
                    ),
                  ),

                  description != ""
                      ? Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              //color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : SizedBox(),
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
    );
  }

  void showDeleteFoodBottomSheet(BuildContext context) {
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
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 1),
                    ),
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
                  style: TextStyle(
                    fontSize: 15,
                    // color: Colors.grey
                  ),
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

  Widget _tabBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tabItem(tr('recent'), 0),
          _tabItem(tr('favorites'), 1),
          _tabItem(tr('personal'), 2),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final selected = foodIntakeController.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => foodIntakeController.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.w),
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
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

  Widget logContainer(String title, String image) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: AppColors.background, width: 1.w),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            image,
            colorFilter: ColorFilter.mode(
              //Colors.black,
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
            height: 20.w,
            width: 20.w,
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
