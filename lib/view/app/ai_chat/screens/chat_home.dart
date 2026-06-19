import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/app/ai_chat/screens/chat_assistant.dart';
import 'package:ark_fit_gym/view/app/ai_chat/screens/talk_ai.dart';
import 'package:ark_fit_gym/view/app/dashboard/controller/dashboard_controller.dart';
  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NoahAiHomeScreen extends StatelessWidget {
  const NoahAiHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 50.w),
                  
                CircleAvatar(
                  radius: 45.r,
                  backgroundImage: AssetImage("assets/images/coach.png"),
                ),
          
                SizedBox(height: 16.w),
          
                Text(
                  tr("hello_noah"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    // color: Colors.black
                  ),
                ),
          
                SizedBox(height: 30.w),
          
                //
                //_actionButton("Personal Nutrition Coach", "assets/icons/Profile.svg"),
                _actionButton(
                  tr("progress_summary"),
                  "assets/icons/progress_analyst.svg",
                  onTap: () {
                    Get.back();
                    Get.find<DashboardController>().changeTab(3);
                  },
                ),
                //_actionButton("Data Translator", "assets/icons/data_translator.svg"),
                _actionButton(
                  tr("talk_to_noah"),
                  "assets/icons/talk_ai.svg",
                  onTap: () => Get.to(() => const TalkWithAi()),
                ),
                _actionButton(
                  tr("chat_noah"),
                  "assets/icons/chat_ai.svg",
                  onTap: () {
                    Get.to(() => ChatAssistantScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text, String iconPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50.w,
        margin: EdgeInsets.only(bottom: 16.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            // White Circle
            Container(
              width: 36.w,
              height: 36.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 20.w,
                  height: 20.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
