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