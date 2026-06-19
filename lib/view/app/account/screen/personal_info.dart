import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/common/custom_date_picker.dart';
import 'package:ark_fit_gym/view/app/account/controller/personal_info_controller.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  late PersonalInfoController personalInfoController;

  @override
  void initState() {
    super.initState();
    personalInfoController = Get.put(PersonalInfoController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          tr("personal_info"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (personalInfoController.isLoading.value) {
          return const Center(child: CircularLoader());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2.w,
                        ),
                      ),
                      child: ClipOval(
                        child: Obx(() {
                          if (personalInfoController.localImage.value != null) {
                            return Image.file(
                              personalInfoController.localImage.value!,
                              fit: BoxFit.cover,
                              width: 100.w,
                              height: 100.w,
                            );
                          } else if (personalInfoController
                              .networkImage
                              .value
                              .isNotEmpty) {
                            return Image.network(
                              personalInfoController.networkImage.value,
                              fit: BoxFit.cover,
                              width: 100.w,
                              height: 100.w,
                              errorBuilder: (context, error, stackTrace) {
                                return Padding(
                                  padding: EdgeInsets.all(15.0.w),
                                  child: SizedBox(
                                    width: 40.w,
                                    height: 40.w,
                                    child: SvgPicture.asset(
                                      "assets/icons/Profile.svg",
                                      width: 20.w,
                                      height: 20.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.all(15.0.w),
                              child: SizedBox(
                                width: 40.w,
                                height: 40.w,
                                child: SvgPicture.asset(
                                  "assets/icons/Profile.svg",
                                  width: 20.w,
                                  height: 20.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: MediaQuery.of(context).size.width / 2 - 110 / 2 - 10,
                    child: GestureDetector(
                      onTap: () {
                        personalInfoController.pickImage();
                      },
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                          color: AppColors.secondary,
                          border: Border.all(color: Colors.white, width: 2.w),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28.w),

              CustomTextField(
                label: tr("first_name"),
                hintText: tr("enter_first_name"),
                controller: personalInfoController.firstNameController,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/Profile.svg",
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18.w),
              CustomTextField(
                label: tr("last_name"),
                hintText: tr("enter_last_name"),
                controller: personalInfoController.lastNameController,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/Profile.svg",
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18.w),
              CustomTextField(
                controller: personalInfoController.emailController,
                label: tr("email"),
                hintText: tr("enter_email"),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/Message.svg",
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.w),
              CustomTextField(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                controller: personalInfoController.phoneController,
                label: tr("phone"),
                hintText: tr("enter_phone_number"),
                //keyboardType: TextInputType.phone,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.phone_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color!,
                  ),
                  //    Center(
                  //     child: SvgPicture.asset(
                  //       "assets/icons/Phone.svg",
                  //       width: 20,
                  //       height: 20,
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                ),
              ),
              SizedBox(height: 18.w),
              CustomTextField(
                controller: personalInfoController.genderController,
                label: tr("gender"),
                hintText: tr("enter_gender"),
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.male_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              SizedBox(height: 18.w),
              CustomTextField(
                readOnly: true,
                controller: personalInfoController.dobController,
                onTap: () async {
                  DateTime? pickedDate = await CustomDatePicker.pickDate(
                    context,
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(pickedDate);

                    personalInfoController.dobController.text = formattedDate;

                    print(formattedDate);
                  }
                },
                label: tr("date_of_birth"),
                hintText: "dd/MM/yyyy",
                suffixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                      height: 20.w,
                      width: 20.w,
                    ),
                  ),
                ),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              _sectionTitle(tr("body_details")),

              CustomTextField(
                label: tr("height"),
                controller: personalInfoController.heightController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.height,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("weight"),
                controller: personalInfoController.weightController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.monitor_weight_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("target_weight"),
                controller: personalInfoController.targetWeightController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.flag_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("BMI"),
                controller: personalInfoController.bmiController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),

              /// ---------- LIFESTYLE ----------
              _sectionTitle(tr("lifestyle")),

              CustomTextField(
                label: tr("goal"),
                controller: personalInfoController.goalController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.track_changes_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("activity_level"),
                controller: personalInfoController.activityController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.directions_run_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("diet_type"),
                controller: personalInfoController.dietController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.restaurant_menu_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),

              /// ---------- MEAL TIMES ----------
              _sectionTitle(tr("meal_timimngs")),

              CustomTextField(
                label: tr("breakfast_time"),
                controller: personalInfoController.breakfastController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.access_time,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("lunch_time"),
                controller: personalInfoController.lunchController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.access_time,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("snack_time"),
                controller: personalInfoController.snackController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.access_time,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              SizedBox(height: 18.w),

              CustomTextField(
                label: tr("dinner_time"),
                controller: personalInfoController.dinnerController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.access_time,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),

              /// ---------- CALORIES ----------
              _sectionTitle(tr("calories")),

              CustomTextField(
                label: tr("daily_calorie_target"),
                controller: personalInfoController.calorieController,
                readOnly: true,
                prefixIcon: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.local_fire_department_outlined,
                    size: 20.w,
                    color: Theme.of(context).iconTheme.color,
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
            title: tr("update"),
            onPressed: () {
              personalInfoController.updateProfile();
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      child: Row(
        children: [
          Text(
            '$title   ',
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
    );
  }
}
