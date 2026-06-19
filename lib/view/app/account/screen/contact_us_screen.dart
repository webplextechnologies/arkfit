import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
       
        title:  Text(
          tr("contact_support"),style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)
          
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _supportTile(
              iconPath: "assets/icons/customer.svg",
              title: tr("customer_support"),
              onTap: () {},
            ),
            _supportTile(
              iconPath: "assets/icons/website.svg",
              title: tr("website"),
              onTap: () {},
            ),
            _supportTile(
              iconPath: "assets/icons/whatsapp.svg",
              title: tr("whatsapp"),
              onTap: () {},
            ),
            _supportTile(
              iconPath: "assets/icons/facebook.svg",
              title: tr("facebook"),
              onTap: () {},
            ),
            _supportTile(
              iconPath: "assets/icons/x.svg",
              title: tr("x"),
              onTap: () {},
            ),
            _supportTile(
              iconPath: "assets/icons/insta.svg",
              title: tr("instagram"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable Tile
  Widget _supportTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin:  EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.primary,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withOpacity(0.15),
          child: SvgPicture.asset(
            iconPath,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.secondary,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
