import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataAnalytics extends StatefulWidget {
  const DataAnalytics({super.key});

  @override
  State<DataAnalytics> createState() => _DataAnalyticsState();
}

class _DataAnalyticsState extends State<DataAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Data & Analytics",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            children: [
               textTile("Data Usage", subtitle:"Control how your data is used for analytics. Customize your preferences."
              ),
              SizedBox(height: 10),
               textTile("Ad Preferences", subtitle:"Manage ad personalization settings. Tailor your ad experience."
              ),
              SizedBox(height: 10),
               textTile("Download My Data", subtitle:"Request a copy of your data. Your information, your control."
              ),
             
            ]
    )]),
    );
    
  }

    Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
         color: Colors.white,
         width: 1 
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget textTile(String title, {String? subtitle, VoidCallback? onTap,}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    //color:  AppColors.text,
                  ),
                ),
                if (subtitle != null) ...[
                   SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style:  TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      //color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
      
          // Trailing Icon
          IconButton(onPressed: (){}, icon: Icon(Icons.chevron_right))
           ,
        ],
      ),
    ),
  );
}
}