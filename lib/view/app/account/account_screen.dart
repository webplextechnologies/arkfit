import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/account/controller/account_controller.dart';
import 'package:ark_fit_gym/view/app/account/screen/account_security.dart';
import 'package:ark_fit_gym/view/app/account/screen/app_appearance.dart';
import 'package:ark_fit_gym/view/app/account/screen/biling_subscription.dart';
import 'package:ark_fit_gym/view/app/account/screen/help_support.dart';
import 'package:ark_fit_gym/view/app/account/screen/personal_info.dart';
import 'package:ark_fit_gym/view/app/account/screen/setting_screen.dart';
import 'package:ark_fit_gym/view/app/account/screen/upgrade_plan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountController accountController;
  @override
  void initState() {
    accountController = Get.put(AccountController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,

              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/icons/icon.png",
                    color: Theme.of(context).iconTheme.color!,
                  ),
                  Text(
                    tr("account"),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                ],
              ),
              // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
            ),
            body: RefreshIndicator(
              color: Theme.of(context).iconTheme.color,
              onRefresh: () async {
                await accountController.fetchProfile(showLoader: false);
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                  /*   GestureDetector(
                      onTap: () {
                        // Navigate to Upgrade Plan Screen
                        Get.to(() => UpgradePlan());
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 40.w,
                              width: 40.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/crown.svg",
                                  colorFilter: ColorFilter.mode(
                                    AppColors.secondary,
                                    BlendMode.srcIn,
                                  ),
                                  height: 30.w,
                                ),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr("upgrade_plan"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.w),
                                  Text(
                                    tr("benefits"),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16.w), */
                    settingsCard([
                      ListTile(
                        leading: Obx(
                          () => CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            child: ClipOval(
                              child: Image.network(
                                accountController.profile.value.profileImage ??
                                    "",
                                fit: BoxFit.cover,
                                width: 40.w,
                                height: 40.w,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    "https://i.pravatar.cc/150",
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        title: Obx(
                          () => Text(
                            "${accountController.profile.value.firstName ?? '--'} ${accountController.profile.value.lastName ?? ''}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        subtitle: Obx(
                          () => Text(
                            accountController.profile.value.email ?? '--',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () => Get.to(() => PersonalInfo()),
                      ),
                    ]),

                    SizedBox(height: 14.w),

                    settingsCard([
                      /*settingTile(
                        "assets/icons/fire.svg",
                        "Calorie Counter",
                        onTap: () => Get.to(() => CalorieCounter()),
                      ),
                      settingTile(
                        "assets/icons/drop.svg",
                        "Water Tracker",
                        onTap: () => Get.to(() => WaterTrackerSettingsPage()),
                      ),
                      settingTile(
                        "assets/icons/footprints.svg",
                        "Step Counter",
                        onTap: () => Get.to(() => StepCounter()),
                      ),
                      settingTile(
                        "assets/icons/weight_counter.svg",
                        "Weight Tracker",
                        onTap: () => Get.to(() => WeightTracker()),
                      ),
                      settingTile(
                        "assets/icons/Setting.svg",
                        "Preferences",
                        onTap: () => Get.to(() => Prefrences()),
                      ),*/
                      settingTile(
                        "assets/icons/Setting.svg",
                        tr("settings"),
                        onTap: () => Get.to(() => SettingScreen()),
                      ),
                      settingTile(
                        "assets/icons/Security.svg",
                        tr("account_security"),
                        onTap: () => Get.to(() => AccountSecurity()),
                      ),
                      // settingTile("assets/icons/linked.svg", "Linked Accounts", onTap: ()=>Get.to(()=>LinkedAccount())),
                      settingTile(
                        "assets/icons/Show.svg",
                        tr("app_appearance"),
                        onTap: () => Get.to(() => AppAppearance()),
                      ),
                      //SettingScreen
                    ]),

                    SizedBox(height: 14.w),

                    /// -------- App Section ----------//
                    settingsCard([
                      // settingTile("assets/icons/Notification.svg", "Notification",onTap: ()=>Get.to(()=>AccountNotification())),
                      // settingTile("assets/icons/Card.svg", "Payment Methods",
                      // onTap: ()=>Get.to(()=>PaymentMethod())),
                     /*  settingTile(
                        "assets/icons/Discount.svg",
                        tr("billing"),
                        onTap: () => Get.to(() => BilingSubscription()),
                      ), */

                      //settingTile("assets/icons/Activity.svg", "Data & Analytics", onTap: ()=>Get.to(()=>DataAnalytics()),),
                      //       settingTile("assets/icons/Activity.svg", "Community", onTap: ()=>Get.to(()=>CommunityScreen()),),
                      settingTile(
                        "assets/icons/Paper.svg",
                        tr("help"),
                        onTap: () => Get.to(() => HelpSupport()),
                      ),
                      settingTile("assets/icons/Star.svg", tr("rate_us"),
                      onTap: () => accountController.openPlayStore(),),
                      settingTile(
                        "assets/icons/Logout.svg",
                        tr("logout"),
                        isLogout: true,
                        onTap: () =>
                            accountController.showLogOutBottomSheet(context),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() {
          return accountController.isLoading.value
              ? Positioned.fill(
                  child: Container(
                    // color: Colors.black.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: CircularLoader(),
                  ),
                )
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  /// ---------- Single Tile ----------
  Widget settingTile(
    String icon,
    String title, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(
          isLogout ? AppColors.secondary : Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
        height: 21.w,
        width: 21.w,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: isLogout
              ? AppColors.secondary
              : Theme.of(context).iconTheme.color!,
        ),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// ---------- Card Wrapper ----------
  Widget settingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(children: children),
    );
  }
}
