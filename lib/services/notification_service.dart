import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService{
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    final IOSInitializationSettings initializationSettingsIOS
    = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final AndroidInitializationSettings initializationSettingsAndroid
    = AndroidInitializationSettings("cloudicon");

    final InitializationSettings initializationSettings
    = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await notificationsPlugin.initialize(
    initializationSettings,
    );
  }

  Future onDidReceiveLocalNotification(int id,
      String? title, String? body, String? payLoad) async {
    Get.dialog(const Text("Welcome to flutter"));
  }
}