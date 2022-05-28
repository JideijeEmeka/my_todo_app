import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/main.dart';
import 'package:my_todo_app/services/notification_service.dart';

NotificationService notificationService = NotificationService();

PreferredSizeWidget homePageAppBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () => {
        themeService.switchTheme(),
        notificationService.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode ? "Activated light theme" : "Activated dark theme")
      },
      child: const Icon(Icons.nightlight_round, size: 20,),
    ),
    actions: const [
      Icon(Icons.person, size: 20,)
    ],
  );
}