import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/theme_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ThemeSheet extends StatefulWidget {
  const ThemeSheet();

  @override
  State<ThemeSheet> createState() => _ThemeSheetState();
}

class _ThemeSheetState extends State<ThemeSheet> {
  String selectedTheme = "light";
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();

    final mode = themeController.currentTheme.value;
    if (mode == ThemeMode.light) {
      selectedTheme = "light";
    } else if (mode == ThemeMode.dark) {
      selectedTheme = "dark";
    } else {
      selectedTheme = "system";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(18.w, 12.w, 18.w, 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            height: 4.w,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          SizedBox(height: 12.w),

          Text(
            tr("choose_theme"),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              //color: AppColors.textPrimary,
            ),
          ),

           Divider(height: 30.w),

          _radioTile("system", "system"),
          _radioTile("light", "light"),
          _radioTile("dark", "dark"),

           SizedBox(height: 30.w),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding:  EdgeInsets.symmetric(vertical: 14.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                  tr("cancel"),

                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

               SizedBox(width: 16.w),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    themeController.setTheme(selectedTheme);
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding:  EdgeInsets.symmetric(vertical: 14.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    tr("ok"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _radioTile(String value, String title) {
    return InkWell(
      onTap: () {
        setState(() => selectedTheme = value);
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: selectedTheme,
            activeColor: AppColors.primary,
            onChanged: (v) {
              setState(() => selectedTheme = v!);
            },
          ),
          Text(
            tr(title),
            style:  TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              // color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
