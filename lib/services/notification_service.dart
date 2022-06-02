import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService{
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    tz.initializeTimeZones();

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
    onSelectNotification: selectNotification);
  }

  void requestIOSPermissions() {
    notificationsPlugin.resolvePlatformSpecificImplementation
    <IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  displayNotification({required String title, required String body}) async {
    debugPrint("doing test");

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "channelId", "channelName",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: "cloud_icon");

    var iosPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await notificationsPlugin.show(
        0,
        title, body,
        platformChannelSpecifics, payload: "Default_Sound");
  }

  scheduledNotification() async {
    notificationsPlugin.zonedSchedule(
        0, "scheduled title", "theme changed 5 seconds ago",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(android: AndroidNotificationDetails(
          "channelId", "channelName",)),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
  
  Future selectNotification(String? payLoad) async{
    if(payLoad != null) {
      debugPrint("Notification payload: $payLoad");
    }else{
      debugPrint("Notification Done");
    }
    Get.to(() => Container(color: Colors.white,));
  }

  Future onDidReceiveLocalNotification(int id,
      String? title, String? body, String? payLoad) async {
    Get.dialog(const Text("Welcome to flutter"));
  }
}