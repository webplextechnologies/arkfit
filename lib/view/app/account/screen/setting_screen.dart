import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/edit_sheet.dart';
import 'package:ark_fit_gym/view/app/account/controller/setting_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool communityNotifications = false;
  late SettingController settingController;

  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    settingController = Get.put(SettingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
             tr("settings"),
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
          ),
          body: Obx(
            () => ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _card(
                  children: [
                    Obx(
                      () => _switchTile(
                       tr("profile_visibility"),
                        settingController.profileVisibility.value,
                        settingController.toggleVisibility,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.w),
                _card(
                  children: [
                    _navTile(
                      tr("calorie_intake_goal"),
                      "${settingController.settingsData.value.calorieGoal ?? '0'} ${settingController.settingsData.value.calorieUnit ?? ''}",
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
                              child: EditSheet(
                                controller:
                                    settingController.calorieGoalController,
                                title: "Calorie Goal",
                                onSave: () {
                                  settingController.saveCalorieGoal();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    _navTile(
                      tr("calorie_units"),
                      settingController.settingsData.value.calorieUnit ?? '',
                      onTap: () async {
                        final selected = await showMenu(
                          color: Theme.of(context).colorScheme.primary,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor, // border color
                              width: 1.w,
                            ),
                          ),
                          context: context,
                          position: RelativeRect.fromLTRB(
                            _tapPosition.dx,
                            _tapPosition.dy,
                            _tapPosition.dx,
                            _tapPosition.dy,
                          ),

                          items: [
                            PopupMenuItem(
                              value: "cal",
                              child: Text(
                                "cal",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "kcal",
                              child: Text(
                                "kcal",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        );

                        if (selected != null) {
                          print(selected);
                          settingController.updateCalorieUnit(selected);
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10.w),
                _card(
                  children: [
                    // _navTile("Current Weight", "80.0 kg"),
                    // _divider(),
                    _navTile(
                      tr("weight_goal"),
                      "${settingController.settingsData.value.weightGoal ?? '0'} ${settingController.settingsData.value.weightUnit ?? ''}",
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
                              child: EditSheet(
                                controller:
                                    settingController.weightGoalController,
                                title: "Weight Goal",
                                 onSave: () {
                                  settingController.saveWeightGoal();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    // _navTile("Height", "185.0 cm"),
                    // _divider(),
                    // _navTile(
                    //   "Weight Units",
                    //   settingController.settingsData.value.weightUnit ?? '',
                    // ),
                    _navTile(
                      tr("weight_units"),
                      settingController.settingsData.value.weightUnit ?? '',

                      onTap: () async {
                        final selected = await showMenu(
                          color: Theme.of(context).colorScheme.primary,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor, // border color
                              width: 1.w,
                            ),
                          ),
                          context: context,
                          position: RelativeRect.fromLTRB(
                            _tapPosition.dx,
                            _tapPosition.dy,
                            _tapPosition.dx,
                            _tapPosition.dy,
                          ),

                          items: [
                            PopupMenuItem(
                              value: "kg",
                              child: Text(
                                "kg",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "pounds",
                              child: Text(
                                "pounds",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        );

                        if (selected != null) {
                          print(selected);
                          settingController.updateWeightUnit(selected);
                        }
                      },
                    ),
                    _divider(),
                    // _navTile(
                    //   "Height Units",
                    //   settingController.settingsData.value.heightUnit ?? '',
                    // ),
                    _navTile(
                      tr("height_units"),
                      settingController.settingsData.value.heightUnit ?? '',
                      onTap: () async {
                        final selected = await showMenu(
                          color: Theme.of(context).colorScheme.primary,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor, // border color
                              width: 1.w,
                            ),
                          ),
                          context: context,
                          position: RelativeRect.fromLTRB(
                            _tapPosition.dx,
                            _tapPosition.dy,
                            _tapPosition.dx,
                            _tapPosition.dy,
                          ),

                          items: [
                            PopupMenuItem(
                              value: "cm",
                              child: Text(
                                "cm",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "inch",
                              child: Text(
                                "inch",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        );

                        if (selected != null) {
                          print(selected);
                          settingController.updateHeightUnit(selected);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.w),
                _card(
                  children: [
                    _navTile(
                      tr("water_intake_goal"),
                      "${settingController.settingsData.value.waterGoal ?? '0'} ${settingController.settingsData.value.waterUnit ?? ''}",
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
                              child: EditSheet(
                                controller:
                                    settingController.waterGoalController,
                                title: "Water Goal",
                                 onSave: () {
                                  settingController.saveWaterGoal();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    _navTile(
                      tr("cup_units"),
                      settingController.settingsData.value.waterUnit ?? '',

                      // _showUnitSelector(
                      //   title: "Water Unit",
                      //   options: ["ml", "L", "fl_oz", "gallons"],
                      //   onSelected: (value) {
                      //     // settingController.updateWaterUnit(value);
                      //   },
                      // );
                      onTap: () async {
                        final selected = await showMenu(
                          color: Theme.of(context).colorScheme.primary,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor, // border color
                              width: 1.w,
                            ),
                          ),
                          context: context,
                          position: RelativeRect.fromLTRB(
                            _tapPosition.dx,
                            _tapPosition.dy,
                            _tapPosition.dx,
                            _tapPosition.dy,
                          ),

                          items: [
                            PopupMenuItem(
                              value: "ml",
                              child: Text(
                                "ml",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "L",
                              child: Text(
                                "L",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "fl_oz",
                              child: Text(
                                "fl oz",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "gallons",
                              child: Text(
                                "gallons",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  // color: AppColors.text,
                                ),
                              ),
                            ),
                          ],
                        );

                        if (selected != null) {
                          print(selected);
                          settingController.updateWaterUnit(selected);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.w),
                _card(
                  children: [
                    _navTile(
                      tr("step_goal"),
                      settingController.settingsData.value.stepGoal ?? '0',
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
                              child: EditSheet(
                                controller:
                                    settingController.stepGoalController,
                                title: "Step Goal",
                                 onSave: () {
                                  settingController.saveStepGoal();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.w),

                _card(
                  children: [
                    _switchTile(
                      tr("push_notifications"),
                      settingController.pushNotifications.value,
                      settingController.togglePush,
                    ),
                    _switchTile(
                      tr("email_notifications"),
                      settingController.emailNotifications.value,
                      settingController.toggleEmail,
                    ),
                    _switchTile(
                      tr("community_notifications"),
                      settingController.communityNotifications.value,
                      settingController.toggleCommunity,
                    ),
                  ],
                ),

                SizedBox(height: 16.w),
              ],
            ),
          ),
        ),
        // Obx(
        //   () => settingController.isLoading.value
        //       ? Container(
        //           color: Colors.black.withOpacity(0.3),
        //           child: Center(child: CircularLoader()),
        //         )
        //       : SizedBox(),
        // ),
      ],
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget _navTile(String title, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapPosition = details.globalPosition;
      },
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                //color: AppColors.text,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              // color: AppColors.text,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      child: Divider(height: 1.w, color: Colors.transparent),
    );
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              //color: AppColors.text,
            ),
          ),
        ),
        Switch(
          value: value,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: AppColors.iconColor,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.secondary,
          trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
