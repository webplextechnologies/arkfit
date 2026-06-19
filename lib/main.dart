import 'dart:ui' as ui;
import 'package:ark_fit_gym/common/app_theme.dart';
import 'package:ark_fit_gym/common/scroll_behavior.dart';
import 'package:ark_fit_gym/firebase_options.dart';
import 'package:ark_fit_gym/services/notifications_services.dart';
import 'package:ark_fit_gym/view/app/account/controller/current_plan_controller.dart';
import 'package:ark_fit_gym/view/app/dashboard/controller/dashboard_controller.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/step_controller.dart';
import 'package:ark_fit_gym/view/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'common/theme_controller.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background Message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  await EasyLocalization.ensureInitialized();
  Get.put(ThemeController(), permanent: true);
  Get.put(DashboardController(), permanent: true);
  Get.put(StepController(), permanent: true);
  Get.put(CurrentPlanController(), permanent: true);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('de', 'DE'),
        Locale('ar', 'SA'),
        Locale('pt', 'BR'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    context.setLocale(locale);
    Get.updateLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController themeController = Get.find<ThemeController>();

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message: ${message.notification?.title}");
      _notificationService.showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification Clicked!");
    });
    _notificationService.checkInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(370, 812),
      splitScreenMode: true,
      builder: (context, child) {
        return Builder(
          builder: (context) {
            final locale = context.locale;
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              scrollBehavior: NoGlowScrollBehavior(),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.currentTheme.value,
              initialRoute: AppRoutes.splash,
              getPages: AppRoutes.routes,
              locale: locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              fallbackLocale: const Locale('en', 'US'),
              builder: (context, child) {
                return Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
