import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountNotification extends StatefulWidget {
  const AccountNotification({super.key});

  @override
  State<AccountNotification> createState() => _AccountNotificationState();
}

class _AccountNotificationState extends State<AccountNotification> {
  bool vibration = false;
  bool stopAt100 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Notifications",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
           _card(
            children: [
               _switchTile("General Notifications", vibration, (v) {
            setState(() => vibration = v);
          }),

          _switchTile("Security Alerts", stopAt100, (v) {
            setState(() => stopAt100 = v);
          }),
          _switchTile("Weekly Progress Summary", vibration, (v) {
            setState(() => vibration = v);
          }),

          _switchTile("Goal Achievement", stopAt100, (v) {
            setState(() => stopAt100 = v);
          }),
          _switchTile("Milestone Celebrations", vibration, (v) {
            setState(() => vibration = v);
          }),

          _switchTile("Health Tips & Article", stopAt100, (v) {
            setState(() => stopAt100 = v);
          }),
          _switchTile("Subscription & Alerts", vibration, (v) {
            setState(() => vibration = v);
          }),

          _switchTile("Social & Community", stopAt100, (v) {
            setState(() => stopAt100 = v);
          }),
          _switchTile("Do Not Disturb", vibration, (v) {
            setState(() => vibration = v);
          }),

          _switchTile("Special Offers", stopAt100, (v) {
            setState(() => stopAt100 = v);
          }),
          _switchTile("Survey and Feedback Requests", vibration, (v) {
            setState(() => vibration = v);
          }),

          _switchTile("Important Announcements", stopAt100, (v) {
            setState(() => stopAt100 = v);
          }),
          _switchTile("App Tips and Tutorials", stopAt100, (v) {
            setState(() => stopAt100 = v);
          }),
            ],
          ),
        
        ],
      ),
    );
  }

    Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
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

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.transparent),
    );
  }
}
