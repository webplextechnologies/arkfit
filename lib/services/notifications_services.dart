import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔰 Initialize everything
  Future<void> init() async {
    await requestPermission();
    await initLocalNotifications();
    await getToken();
    listenTokenRefresh();
  }

  /// 🔐 Request permission
  Future<void> requestPermission() async {
    NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission: ${settings.authorizationStatus}");
  }

  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize( settings: settings);
  }

  Future<void> getToken() async {
    String? token = await _messaging.getToken();
    print("🔥 FCM Token: $token");
  }

  void listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      print("♻️ New Token: $newToken");
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: 0,
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      notificationDetails: details,
    );
  }

  Future<void> checkInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print("🚀 App opened from terminated state");
    }
  }
}