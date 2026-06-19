
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SvgPicture.asset(
              'assets/icons/Setting.svg',
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
      /* body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          _dateHeader("Today, Dec 22, 2024"),
          SizedBox(height: 6),
          _notificationItem(
            icon: "assets/icons/Star.svg",
            title: "Daily Step Goal Achieved!",
            subtitle:
                "Awesome job! You've hit your step goal for the day. Keep moving!",
            time: "09:41 AM",
            unread: true,
          ),
          _notificationItem(
            icon: "assets/icons/Activity.svg",
            title: "Weekly Progress Report",
            subtitle:
                "Great job this week! Check your progress in the Tracker menu.",
            time: "09:35 AM",
            unread: true,
          ),
          _notificationItem(
            icon: "assets/icons/Paper.svg",
            title: "New Article Available",
            subtitle:
                "Check out the latest tips on healthy eating in our Articles section.",
            time: "08:09 AM",
          ),
          _dateHeader("Dec 21, 2024"),
          SizedBox(height: 6),
          _notificationItem(
            icon: "assets/icons/Ticket.svg",
            title: "Join Our Challenge!",
            subtitle: "Compete with friends and reach your goals together.",
            time: "16:00 PM",
          ),
          _notificationItem(
            icon: "assets/icons/Security.svg",
            title: "Account Security Update",
            subtitle: "For your safety, please verify your account details.",
            time: "10:27 AM",
          ),
          _dateHeader("Dec 20, 2024"),
          SizedBox(height: 6),
          _notificationItem(
            icon: "assets/icons/Discount.svg",
            title: "Don't Miss Out!",
            subtitle: "Get special discount on premium features.",
            time: "09:15 AM",
          ),
        ],
      ), */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Notification.svg',
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
              height: 50.w,
              width: 50.w,
            ),

            SizedBox(height: 20.h),

            //Title
            Text(
              "No Notifications Yet",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 10.h),

            //Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                "You're all caught up! We'll notify you when something new arrives.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  //color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateHeader(String text) {
    return Row(
      children: [
        Text(
          '${text}   ',
          style: TextStyle(
            fontSize: 14.sp,
            //color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Divider(thickness: 0.5, color: Theme.of(context).dividerColor),
        ),
      ],
    );
  }

  Widget _notificationItem({
    required String icon,
    required String title,
    required String subtitle,
    required String time,
    bool unread = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xffEEEEEE)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
                height: 24,
                width: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          // color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    // color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    //a color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          SvgPicture.asset(
            'assets/icons/arrow-right.svg',
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),

            height: 24,
            width: 24,
          ),
          //const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
