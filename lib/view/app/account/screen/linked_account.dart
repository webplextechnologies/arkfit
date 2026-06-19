import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinkedAccount extends StatefulWidget {
  const LinkedAccount({super.key});

  @override
  State<LinkedAccount> createState() => _LinkedAccountState();
}

class _LinkedAccountState extends State<LinkedAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Linked Accounts",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,),
        child: Column(
          children: [
            SizedBox(height: 12),
            socialTile("assets/icons/google.png", "Google", "Linked", isLinked: true),
            SizedBox(height: 10),
            socialTile("assets/icons/facebook.png", "Facebook", "Linked",isLinked: true),
            SizedBox(height: 10),
            socialTile("assets/icons/apple.png", "Apple", "Link"),
            SizedBox(height: 10),
            socialTile("assets/icons/x.png", "Twitter", "Link",),
          ],
        ),
      ),
    );
  }

  Widget socialTile(String icon, String title, String subtitle,{bool isLinked = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border:  Border.all(
         color: Colors.white,
         width: 1 
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 60, height: 60),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
             // color: AppColors.text,
            ),
          ),
          Spacer(),
          Text(
            subtitle, 
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: isLinked ? Theme.of(context).iconTheme.color : AppColors.secondary,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}
