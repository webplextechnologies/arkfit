import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalorieCounter extends StatefulWidget {
  const CalorieCounter({super.key});

  @override
  State<CalorieCounter> createState() =>
      _CalorieCounterState();
}

class _CalorieCounterState extends State<CalorieCounter> {
  bool drinkReminder = true;
  bool vibration = false;
  bool stopAt100 = false;

  double volume = 0.6;

  bool t12 = false;
  bool t2 = false;
  bool t4 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Calorie Counter",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// GOAL CARD
          _card(
            children: [
              _navTile("Calorie Intake Goal", "2,560 kcal"),
              _divider(),
              _navTile("Units", "kcal"),
            ],
          ),

          const SizedBox(height: 16),

          /// REMINDER CARD
          /*_card(
            children: [
              _switchTile("Meal Logging Reminder", drinkReminder, (v) {
                setState(() => drinkReminder = v);
              }),
              _divider(),
              _navTile("Repeat", "Everyday"),
              _divider(),
              _navTile("Reminder Time", "08:00 AM"),
              _divider(),
              _navTile("Ringtone", "Harmony"),

              const SizedBox(height: 10),

              /// VOLUME SLIDER
              Row(
                children: [
                  const Icon(Icons.volume_off),
                  Expanded(
                    child: Slider(
                      value: volume,
                      activeColor: AppColors.secondary,
                      inactiveColor:AppColors.background ,
                      onChanged: (v) {
                        setState(() => volume = v);
                      },
                    ),
                  ),
                  const Icon(Icons.volume_up),
                ],
              ),

              _divider(),
              _switchTile("Vibration", vibration, (v) {
                setState(() => vibration = v);
              }),
              _divider(),
              _switchTile("Stop When 100%", stopAt100, (v) {
                setState(() => stopAt100 = v);
              }),
            ],
          ),*/

         
        ],
      ),
    );
  }

  // ------------------------------------------------

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

  Widget _navTile(String title, String value) {
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

  Widget _timeSwitch(String time, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
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
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1,
      color: Colors.transparent),
    );
  }
}
