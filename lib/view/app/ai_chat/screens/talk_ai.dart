import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/app/ai_chat/controller/chat_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TalkWithAi extends StatefulWidget {
  const TalkWithAi({super.key});

  @override
  State<TalkWithAi> createState() => _TalkWithAiState();
}

class _TalkWithAiState extends State<TalkWithAi> {
  late ChatController controller;
  @override
  void initState() {
    controller = Get.put(ChatController());
    super.initState();
  }

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
        child: Center(
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/talk_ai_bg.png",
                    height: 150,
                  ),

                  SizedBox(height: 20),

                  Text(
                    tr("hi_help"),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    // controller.isListening.value
                    //     ? controller.messageController.text.isEmpty
                    //         ? "Listening..."
                    //         : controller.messageController.text
                    //     :
                         tr("what_to_do"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 30),

                  /// 🎤 MIC BUTTON
                  GestureDetector(
                    onTapDown: (_) => controller.startListening(),
                    onTapUp: (_) => controller.stopListening(),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: controller.isListening.value
                          ? Colors.red
                          : AppColors.primary,
                      child: Icon(
                        controller.isListening.value
                            ? Icons.mic
                            : Icons.mic_none_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    controller.isListening.value
                        ? "${tr('listening')}..."
                        : tr("hold_to_speak"),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 20),

                  /// 🔄 Loading Indicator
                  if (controller.isLoading.value)
                    CircularProgressIndicator(),
                ],
              )),
        ),
      ),
    );
  }
}

/*class TalkWithAi extends StatelessWidget {
  const TalkWithAi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/talk_ai_bg.png", height: 150),

               SizedBox(height: 20),

               Text(
                "Hi, I'm here to help",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

               SizedBox(height: 8),

               Text(
                "What would you like to do today?",
                style: TextStyle(
                 // color: AppColors.textSecondary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

               SizedBox(height: 30),

              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.mic_none_sharp,
                  color: Colors.white,
                  size: 30,
                ),
              ),

               SizedBox(height: 12),

               Text(
                "Tap to speak",
                style: TextStyle(
                 // color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
