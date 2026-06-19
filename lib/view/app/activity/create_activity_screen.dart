import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/activity/controller/create_activity_controller.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
    late CreateActivityController createActivityController;

  @override
  void initState() {
    createActivityController = Get.put(CreateActivityController());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
        ),
        centerTitle: true,
        title: Text(tr("create_activity"), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold,),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            GestureDetector(
              onTap: createActivityController.pickImage,
              child: Center(
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child:  Obx(
                    ()=> ClipOval(
                        child: createActivityController.profileImage.value != null
                            ? Image.file(
                                createActivityController.profileImage.value!,
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
            ),

             SizedBox(height: 30),
            Divider(thickness: 0.5),

            SizedBox(height: 10),

            CustomTextField(
controller: createActivityController.nameController,
              label: tr("activity_name"),
              hintText: tr("example_activity"),
              showFocusBorder: false,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
            ),

             SizedBox(height: 20),
            CustomTextField(
              controller: createActivityController.calController,

              label: tr("calorie_per_min"),
              hintText: tr("example_calorie"),

              showFocusBorder: false,

              fillColor: Theme.of(context).scaffoldBackgroundColor,
            ),
             SizedBox(height: 20),
            // CustomTextField(
            //  label: "Duration",
            //  hintText: "Duration",
            //  showFocusBorder: false,
            //  fillColor: Theme.of(context).scaffoldBackgroundColor,
            // ),
          ],
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
          child: CustomButton(icon: Icons.add, title: " ${tr('add')}", onPressed: () {
            createActivityController.createActivity();
          }),
        ),
      ),
    );
  }
}
