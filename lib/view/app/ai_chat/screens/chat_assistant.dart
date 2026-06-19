
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/app/ai_chat/controller/chat_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatAssistantScreen extends StatelessWidget {
  ChatAssistantScreen({super.key});

  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              tr("chat_assistant"),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child:  Text("AI", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45.r,
                      backgroundImage: AssetImage("assets/images/coach.png"),
                    ),

                    SizedBox(height: 16.w),

                    Text(
                      tr("talk_to_noah"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        // color: Colors.black
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                controller: chatController.scrollController,
                padding: EdgeInsets.all(16.w),
                itemCount:
                    chatController.messages.length +
                    (chatController.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (chatController.isTyping.value &&
                      index == chatController.messages.length) {
                    return _typingBubble();
                  }

                  var msg = chatController.messages[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: msg["isUser"]
                        ? _userBubble(msg["message"], msg["time"])
                        : _botBubble(msg["message"], msg["time"]),
                  );
                },
              );
            }),
          ),

          _suggestionRow(context),
          _inputBar(context),
        ],
      ),
    );
  }

  /// ================= BOT MESSAGE =================
  Widget _botBubble(String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            "assets/images/coach.png",
            height: 36.w,
            width: 36.w,
          ),
        ),
        SizedBox(width: 8.w),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= USER MESSAGE =================
  Widget _userBubble(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 15.sp),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            time,
            style: TextStyle(color: Colors.grey, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  /// ================= TYPING INDICATOR =================
  Widget _typingBubble() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/coach.png"),
          radius: 16,
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Coach is thinking 💭",
            style: TextStyle(color: Colors.black, fontSize: 15.sp),
          ),
        ),
      ],
    );
  }

  /// ================= SUGGESTIONS =================
  Widget _suggestionRow(context) {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(bottom: 5.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            _chip(tr("diet_plan"), context),
            _chip(tr("workout_tips"), context),
            _chip(tr("calories_help"),context),
            _chip(tr("fat_loss"), context),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, context) {
    return GestureDetector(
      onTap: () {
        chatController.messageController.text = text;
        chatController.sendMessage(context);
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          text,
          style: TextStyle(color: AppColors.primary, fontSize: 13.sp),
        ),
      ),
    );
  }

  /// ================= INPUT BAR =================
  Widget _inputBar(context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController.messageController,
             // textCapitalization: TextCapitalization.words,
              style: TextStyle(color: Colors.black, fontSize: 15.sp),
              decoration: InputDecoration(
                hintText: "${tr("type_question")}...",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          GestureDetector(
            onTap: () {
              chatController.sendMessage(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 20.w),
            ),
          ),
        ],
      ),
    );
  }
}
