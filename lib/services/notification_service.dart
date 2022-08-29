import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
      = FlutterLocalNotificationsPlugin();
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
    BehaviorSubject<ReceiveNotification>();

    init() {
      if(Platform.isIOS) {
        requestIOSPermission();
      }
      initializePlatform();
    }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation
    <IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  initializePlatform() {
    _configureLocalTimeZone();
    var initSettingAndroid = const AndroidInitializationSettings('icon_notification_replace');
    var initSettingIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        ReceiveNotification notification = ReceiveNotification(
            id: id, title: title, body: body, payload: payload);
        didReceiveLocalNotificationSubject.add(notification);
      }
    );
    initSetting = InitializationSettings(
        android: initSettingAndroid,
        iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
      onSelectNotification: (String? payload) async {
        onNotificationClick(payload);
      }
    );
  }

  Future<void> showNotification({required String title,
    required String body, required String payload}) async {
    var androidChannel = const AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME',
        channelDescription: 'CHANNEL_DESCRIPTION',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        icon: 'icon_notification_replace',
        timeoutAfter: 5000,
        enableLights: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'));
    var iosChannel = const IOSNotificationDetails(sound: 'notification_sound.mp3');
    var platformChannel = NotificationDetails(
        android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannel,
        payload: payload);
  }

  scheduleNotification({required int hour,
      required int minutes, required Task task}) {
    flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        task.title,
        task.note,
        _convertTime(hour, minutes),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
            'CHANNEL_ID_1', 'CHANNEL_NAME_1',
            channelDescription: 'CHANNEL_DESCRIPTION_1',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            timeoutAfter: 5000,
            enableLights: true,
            icon: 'icon_notification_replace',
            sound: RawResourceAndroidNotificationSound('notification_sound')),
        iOS: IOSNotificationDetails(sound: 'notification_sound.mp3')),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|""${task.note}|""${task.date}|""${task.startTime}|",
        androidAllowWhileIdle: true);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minutes);
    if(scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

}

class ReceiveNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  ReceiveNotification({required this.id, required this.title,
    required this.body, required this.payload});
}