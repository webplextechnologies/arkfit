import 'package:ark_fit_gym/common/theme_controller.dart';
import 'package:ark_fit_gym/view/app/account/screen/app_language.dart';
import 'package:ark_fit_gym/view/app/account/widget/theme_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppAppearance extends StatefulWidget {
  const AppAppearance({super.key});

  @override
  State<AppAppearance> createState() => _AppAppearanceState();
}

class _AppAppearanceState extends State<AppAppearance> {
  final ThemeController themeController = Get.find<ThemeController>();

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      default:
        return "system";
    }
  }

  String getLanguageFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return "Hindi(हिन्दी)";
      case 'es':
        // Ensure the spelling matches your list exactly (Spanish vs Español)
        return "Spanish(Español)";
      case 'fr':
        return "French(Français)";
      case 'de':
        return "German(Deutsch)";
      case 'ar':
        return "Arabic(العربية)";
      case 'pt':
        return "Portuguese(Português)";
      default:
        return "English";
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          tr("app_appearance"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card(
              children: [
                Obx(
                  () => _navTile(
                    tr("theme"),
                    tr(_getThemeName(themeController.currentTheme.value)),
                    onTap: () => showThemeBottomSheet(context),
                  ),
                ),

                const SizedBox(height: 15),
                _navTile(
                  tr("app_language"),
                  getLanguageFromLocale(locale),
                  onTap: () {
                    Get.to(() => AppLanguageScreen());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white),
      ),
      child: Column(children: children),
    );
  }

  Widget _navTile(String title, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
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
              //color: AppColors.text,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  void showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Theme.of(context).colorScheme.primary,
              border: Border(top: BorderSide(color: Colors.white, width: 1)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: const ThemeSheet(),
          ),
        );
      },
    );
  }
}
