import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/account/account_screen.dart';
import 'package:ark_fit_gym/view/app/account/screen/upgrade_plan.dart';
import 'package:ark_fit_gym/view/app/ai_chat/screens/chat_home.dart';
import 'package:ark_fit_gym/view/app/insights/insights_screen.dart';
import 'package:ark_fit_gym/view/app/dashboard/controller/dashboard_controller.dart';
import 'package:ark_fit_gym/view/app/home/home_screen.dart';
import 'package:ark_fit_gym/view/app/tracker/tracker_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
//import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController dashboardController;

  // @override
  // void initState() {
  //   dashboardController = Get.put(DashboardController());
  //   dashboardController.currentIndex.value = 0;
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();

    dashboardController = Get.put(DashboardController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardController.currentIndex.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeScreen(),
      TrackerScreen(),
      //ScannerScreen(),
      SizedBox(),
      InsightsScreen(),
      AccountScreen(),
    ];

    return Stack(
      children: [
        Scaffold(
          body: Obx(
            () => IndexedStack(
              index: dashboardController.currentIndex.value,
              children: pages,
            ),
          ),
          floatingActionButton: Obx(
            () => dashboardController.currentIndex.value == 2
                ? SizedBox()
                : coachFloatingButton(dashboardController.isPremiumUser.value),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: Obx(
            () => dashboardController.currentIndex.value != 2
                ? SafeArea(
                    child: Container(
                      color: Colors.white,
                      height: 70.h,
                      child: BottomNavigationBar(
                        currentIndex: dashboardController.currentIndex.value,

                        /*  onTap: (index) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (index == 2) {
                              // dashboardController.scanFromCamera();
                              dashboardController.showScanOptions(context);
                            } else {
                              dashboardController.changeTab(index);
                            }
                          });
                        }, */
                        onTap: (index) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (index == 2) {
                               dashboardController.showScanOptions(context);
                             /*  if (dashboardController.isPremiumUser.value) {
                                dashboardController.showScanOptions(context);
                              } else {
                                Get.to(() => UpgradePlan());
                              } */
                            } else {
                              dashboardController.changeTab(index);
                            }
                          });
                        },

                        selectedItemColor: AppColors.secondary,
                        unselectedItemColor: Colors.grey,
                        type: BottomNavigationBarType.fixed,
                        items: [
                          BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              'assets/icons/Home.svg',
                              colorFilter: ColorFilter.mode(
                                AppColors.iconColor,
                                BlendMode.srcIn,
                              ),
                              height: 24.w,
                              width: 24.w,
                            ),
                            activeIcon: SvgPicture.asset(
                              'assets/icons/Home_colored.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.secondary,
                                BlendMode.srcIn,
                              ),
                              height: 24.w,
                              width: 24.w,
                            ),
                            label: tr('home'),
                          ),
                          BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              'assets/icons/Category.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.iconColor,
                                BlendMode.srcIn,
                              ),

                              height: 24.w,
                              width: 24.w,
                            ),
                            activeIcon: SvgPicture.asset(
                              'assets/icons/Category_colored.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.secondary,
                                BlendMode.srcIn,
                              ),
                              height: 24.w,
                              width: 24.w,
                            ),
                            label: tr('tracker'),
                          ),

                          BottomNavigationBarItem(
                            icon: Transform.translate(
                              offset: const Offset(0, 6),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 28.w,
                              ),
                              /*SvgPicture.asset(
                                  'assets/icons/scanner.svg',
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.iconColor,
                                    BlendMode.srcIn,
                                  ),
                                  height: 28,
                                  width: 30,
                                ),*/
                            ),
                            activeIcon: Transform.translate(
                              offset: const Offset(0, 6),
                              child: SvgPicture.asset(
                                'assets/icons/scanner.svg',
                                colorFilter: const ColorFilter.mode(
                                  AppColors.secondary,
                                  BlendMode.srcIn,
                                ),
                                height: 28,
                                width: 30,
                              ),
                            ),
                            label: '',
                          ),

                          BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              //'assets/icons/Paper.svg',
                              'assets/icons/Activity.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.iconColor,
                                BlendMode.srcIn,
                              ),
                              height: 24.w,
                              width: 24.w,
                            ),
                            activeIcon: SvgPicture.asset(
                              'assets/icons/Activity_colored.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.secondary,
                                BlendMode.srcIn,
                              ),
                              height: 24.w,
                              width: 24.w,
                            ),
                            //  label: 'Articles',
                            label: tr('insights'),
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SvgPicture.asset(
                                'assets/icons/Profile.svg',
                                colorFilter: const ColorFilter.mode(
                                  AppColors.iconColor,
                                  BlendMode.srcIn,
                                ),
                                height: 24.w,
                                width: 24.w,
                              ),
                            ),
                            activeIcon: SvgPicture.asset(
                              'assets/icons/Profile_colored.svg',
                              colorFilter: const ColorFilter.mode(
                                AppColors.secondary,
                                BlendMode.srcIn,
                              ),

                              height: 24.w,
                              width: 24.w,
                            ),
                            label: tr("account"),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ),
        Obx(
          () => dashboardController.isLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularLoader()),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  Widget coachFloatingButton(bool isPremium) {
    return GestureDetector(
      onTap: () {
        Get.to(() => NoahAiHomeScreen());
       /*  if (isPremium) {
          Get.to(() => NoahAiHomeScreen());
        } else {
          Get.to(() => UpgradePlan());
        } */
      },
      child: /* Opacity(
        opacity: isPremium ? 1 : 0.6,
        child: */ Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          height: 66.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.orange, width: 2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr("talk_to"), style: TextStyle(fontSize: 12.sp)),
                  Text(
                    tr("noah_ai"),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Image.asset(
                  "assets/images/coach.png",
                  height: 55.w,
                  width: 55.w,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
     // ),
    );
  }
}
