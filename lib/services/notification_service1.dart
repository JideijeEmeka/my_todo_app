import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/UI/notified_page.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService{
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    //tz.initializeTimeZones();
    // _configureLocalTimeZone();

    final IOSInitializationSettings initializationSettingsIOS
    = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    const AndroidInitializationSettings initializationSettingsAndroid
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

  ///Display Notification
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
        platformChannelSpecifics, payload: title);
  }

  /// Scheduled Notification
  scheduledNotification(int hour, int minutes, Task task) async {
    notificationsPlugin.zonedSchedule(
        task.id!, task.title, task.note,
        _convertTime(hour, minutes),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(android: AndroidNotificationDetails(
          "channelId", "channelName", channelDescription: "Channel description")),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|""${task.note}|",
        androidAllowWhileIdle: true);
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local,
        now.year, now.month, now.day, hour, minutes);
    if(scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future selectNotification(String? payLoad) async{
    if(payLoad != null) {
      debugPrint("Notification payload: $payLoad");
    }else{
      debugPrint("Notification Done");
    }
    if(payLoad == "Theme Changed") {
      debugPrint('Nothing to navigate');
    }else {
      Get.to(() => NotifiedPage(label: payLoad,));
    }
  }

  Future onDidReceiveLocalNotification(int id,
      String? title, String? body, String? payLoad) async {
    Get.dialog(const Text("Welcome to flutter"));
  }
}