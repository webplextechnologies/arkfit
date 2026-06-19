import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Prefrences extends StatefulWidget {
  const Prefrences({super.key});

  @override
  State<Prefrences> createState() => _PrefrencesState();
}

class _PrefrencesState extends State<Prefrences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Prefrences",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            children: [
              _navTile("First Day of Week", "Monday"),
              _divider(),
              _navTile("Time Format", "System Default"),
              _divider(),
              _navTile("Day Reset Time", "00:00 AM"),

               
            ],
          ),

          SizedBox(height: 20),

           _card(
            children: [
              _navTile("Restart All Progress", ""),
              _divider(),
              _navTile("Clear Cache", "45.8 MB"),
            
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: Colors.transparent),
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
}
