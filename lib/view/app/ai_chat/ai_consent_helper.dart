import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/app/account/screen/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';


class AiConsentHelper {
  static const String consentKey = "ai_user_consent";

  // Check if consent already given
  static Future<bool> hasConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(consentKey) ?? false;
  }

  // Save consent
  static Future<void> saveConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(consentKey, value);
  }

  // Show Apple-compliant consent dialog
  static Future<bool> showConsentDialog(BuildContext context) async {
    final alreadyAccepted = await hasConsent();

    if (alreadyAccepted) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title:  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.privacy_tip_outlined),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  tr("title"),//"AI Assistant & Data Processing Consent",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          /*content: Text(
            "This app uses third-party AI services to process user inputs "
            "and generate responses. Certain data such as messages or uploaded "
            "content may be securely shared with AI providers.\n\n"
            "By continuing, you agree to this processing as described in our Privacy Policy.",
            style: TextStyle(fontSize: 15),
          ), */
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                 /*  "ArkFit uses Google's Gemini AI service to provide personalized "
                  "fitness, workout, nutrition, and wellness recommendations.\n\n"
                  "When using the AI Chat feature, information you provide may be "
                  "securely transmitted to Google's Gemini AI service, including:\n\n"
                  "• Chat messages and prompts\n"
                  "• Fitness goals\n"
                  "• Age, gender, height, and weight\n"
                  "• Workout and nutrition preferences\n"
                  "• Health and fitness information you choose to share\n\n"
                  "This information is used only to generate AI-powered responses.", */
                  tr('content'),
                  style: TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: () async {
                    Get.to(PrivacyPolicy());
                  },
                  child: Text(
                    //"View Privacy Policy",
                    tr("privacy"),
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                tr("cancel"),
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.primary),
              ),
              onPressed: () async {
                await saveConsent(true);

                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              child:  Text(
                //"Agree & Continue",
                tr('agreeAi'),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
