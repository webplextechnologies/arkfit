import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const _key = 'theme_mode';

  final Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    switch (saved) {
      case 'light':
        currentTheme.value = ThemeMode.light;
        break;
      case 'dark':
        currentTheme.value = ThemeMode.dark;
        break;
      default:
        currentTheme.value = ThemeMode.system;
    }

    Get.changeThemeMode(currentTheme.value);
  }

  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();

    switch (theme) {
      case 'light':
        currentTheme.value = ThemeMode.light;
        await prefs.setString(_key, 'light');
        break;

      case 'dark':
        currentTheme.value = ThemeMode.dark;
        await prefs.setString(_key, 'dark');
        break;

      default:
        currentTheme.value = ThemeMode.system;
        await prefs.setString(_key, 'system');
    }

    Get.changeThemeMode(currentTheme.value);
  }
}
