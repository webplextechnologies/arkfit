import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Community",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BLOG TITLE
              SizedBox(height: 12.w),
              Text(
                "Blog",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10.w),
              /// BLOG HORIZONTAL LIST
              SizedBox(
                height: 260.w,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    blogCard(
                      image: "assets/images/coach.png",
                      category: "Education",
                    ),
                    SizedBox(width: 10.w),
                    blogCard(
                      image: "assets/images/talk_ai_bg.png",
                      category: "Lifestyle",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              /// FORUM TITLE
              Text(
                "Forum",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 2.h),

              /// FORUM LIST
              Expanded(
                child: ListView(
                  children: [
                    forumItem("Your Most Favourite Release....", "assets/icons/fire.svg"),
                    forumItem("Water Tracker","assets/icons/drop.svg"),
                    forumItem("Step Counter", "assets/icons/footprints.svg"),
                    forumItem("Weight Tracker","assets/icons/weight_counter.svg"),
                    forumItem("Preferences","assets/icons/Setting.svg"),
                  ],
                ),
              ),

            
            
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding:  EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: CustomButton(
          
            title: "Continue", onPressed: () {}),
        ),
      ),
    );

    
  }

  /// BLOG CARD
  Widget blogCard({required String image, required String category}) {
    return Container(
      width: 250.w,
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              image,
              height: 120.w,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 6.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),

                SizedBox(height: 2.w),

                Text(
                  "3 Common Exercise & How to Combat Them",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),

                SizedBox(height: 2.w),

                /// DESCRIPTION
                Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting..",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// FORUM ITEM
  Widget forumItem(String title, String icon) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0.5.h),
     
      leading: CircleAvatar(
        backgroundColor: AppColors.secondary,
        child: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(
           Colors.white ,
          BlendMode.srcIn,
        ),
        height: 20.w,
        width: 20.w,
            ),
      ),
      title: Text(
        title,
        style:  TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
      ),
      subtitle:  Text(
        "September 10 at 2:51 PM",
        style: TextStyle(color: Colors.grey,fontSize: 12.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children:  [
          Text("65", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          SizedBox(width: 5),
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}