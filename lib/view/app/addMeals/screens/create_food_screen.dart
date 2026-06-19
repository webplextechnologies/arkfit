import 'dart:io';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/view/app/addMeals/controller/create_food_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateFoodScreen extends StatefulWidget {
  const CreateFoodScreen({super.key});

  @override
  State<CreateFoodScreen> createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  late CreateFoodController createFoodController;
  @override
  void initState() {
    createFoodController = Get.put(CreateFoodController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color!),
            ),
            centerTitle: true,
            title: Text(tr("create_food")),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 2.w),
                      ),
                      child: ClipOval(
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: 100.w,
                                height: 100.w,
                              )
                            : Icon(
                                Icons.add,
                                size: 40.w,
                                color: Theme.of(context).iconTheme.color,
                              ),
                      ),
                    ),
                  ),
                ),
        
                SizedBox(height: 30.w),
                Divider(thickness: 0.5),
        
                SizedBox(height: 10.w),
        
                CustomTextField(
                  label: tr("food_name"),
                  hintText: tr("eg_food"),
                  showFocusBorder: false,
                 controller: createFoodController.nameController,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                ),
        
                SizedBox(height: 20.w),
        
                /// Serving & Unit
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                         controller: createFoodController.servingUnitController,
                        label: tr("serving"),
                        hintText: tr("example_calorie"),
                        showFocusBorder: false,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextField(
                         controller: createFoodController.unitController,
                        label: tr("unit"),
                        hintText: tr("eg_gram_ml"),
                        showFocusBorder: false,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
        
                SizedBox(height: 20.w),
        
                /// Calories & Carbs
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: "${tr("calories")} (kcal)",
                            hintText:  tr("example_calorie"),
                            showFocusBorder: false,
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            controller: createFoodController.caloriesController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextField(
                          controller: createFoodController.carbsController,
                        label: "${tr("carbs")} (g)",
                        hintText:  tr("example_calorie"),
                        showFocusBorder: false,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
        
                SizedBox(height: 20.w),
        
                /// Protein & Fat
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: createFoodController.proteinController,
                        label: "${tr("protein")} (g)",
                        hintText: tr("example_calorie"),
                        showFocusBorder: false,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
        
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextField(
                        controller: createFoodController.fatsController,
                        label: "${tr("fat")} (g)",
                        hintText:  tr("example_calorie"),
                        showFocusBorder: false,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                onPressed: () {
                  createFoodController.createFood();
                },
              ),
            ),
          ),
        ),
        Obx(
          () => createFoodController.isLoading.value
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
