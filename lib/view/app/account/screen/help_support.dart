import 'package:ark_fit_gym/view/app/account/screen/faq_screen.dart';
import 'package:ark_fit_gym/view/app/account/screen/privacy_policy.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          tr("help"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        child: Column(
          children: [
            _card(
              children: [
                textTile(
                  tr("faqs"),
                  onTap: () {
                    Get.to(() => const FaqScreen());
                  },
                ),
                // textTile(tr("contact_us"),
                //     onTap: () {
                //       Get.to(() => const ContactSupportScreen());
                //     }),
                // textTile(tr("terms_of_service"),
                // onTap: () => Get.to(() => const TermsConditions(),),
                // ),
                textTile(tr("privacy_policy"),
                  onTap: () => Get.to(() => const PrivacyPolicy())),
                // textTile("Partner"),
                // textTile("Job vacancies"),
                // textTile("Accessibility"),
                // textTile("Feedback"),
                // textTile("About Us"),
                // textTile("Rate us"),
                // textTile("Visit Our Website"),
                // textTile("Follow us on Social Media"),
              ],
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() =>  NoahAiHomeScreen());
        },
        backgroundColor: AppColors.primary,
        child: SvgPicture.asset( "assets/icons/ai_chat.svg",
        height: 24,
         colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
      )*/
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget textTile(String title, {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            //Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      //color: AppColors.text,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
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
            IconButton(
              onPressed: () {
                if (onTap != null) {
                  onTap();
                }
              },
              icon: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
