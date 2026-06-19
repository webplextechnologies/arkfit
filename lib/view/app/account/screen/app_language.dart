
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppLanguageScreen extends StatefulWidget {
  const AppLanguageScreen({super.key});

  @override
  State<AppLanguageScreen> createState() => _AppLanguageScreenState();
}

class _AppLanguageScreenState extends State<AppLanguageScreen> {
  String selectedLanguage = "";

  final List<String> languages = [
    "English",
    "Hindi(हिन्दी)",
    "Spanish(Español)",
    "German(Deutsch)",
    "French(Français)",
    "Arabic(العربية)",
    "Portuguese(Português)",
  ];

  Locale getLocale(String lang) {
    switch (lang) {
      case "Hindi(हिन्दी)":
        return Locale('hi', 'IN');
      case "Spanish(Español)":
        return Locale('es', 'ES');
      case "French(Français)":
        return Locale('fr', 'FR');
      case "German(Deutsch)":
        return Locale('de', 'DE');
      case "Arabic(العربية)":
        return Locale('ar', 'SA');
      case "Portuguese(Português)":
        return Locale('pt', 'BR');
      default:
        return Locale('en', 'US');
    }
  }

  String getLanguageFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return "Hindi(हिन्दी)";
      case 'es':
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLang = getLanguageFromLocale(context.locale);

    if (selectedLanguage != currentLang) {
      setState(() {
        selectedLanguage = currentLang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          tr("app_language"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white, width: 1.w),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: languages.length,
            separatorBuilder: (_, __) =>
                Divider(height: 0.1.w, color: Theme.of(context).dividerColor),
            itemBuilder: (context, index) {
              final lang = languages[index];
              final isSelected = lang == selectedLanguage;

              return InkWell(
                onTap: () async{
                  final locale = getLocale(lang);
                 await context.setLocale(locale);
                 MyApp.setLocale(context, locale);
                  setState(() => selectedLanguage = lang);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lang,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check,
                          color: AppColors.secondary,
                          size: 20.w,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
