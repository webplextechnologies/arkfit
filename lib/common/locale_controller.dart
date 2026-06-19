import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  var locale = const Locale('en', 'US').obs;

  void changeLocale(BuildContext context, Locale newLocale) async {
    await context.setLocale(newLocale);
    locale.value = newLocale;
    print("Locale changed to: ${locale.value}");
  }
}