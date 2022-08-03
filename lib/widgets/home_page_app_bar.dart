import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/main.dart';
import 'package:my_todo_app/services/notification_service.dart';
import 'package:my_todo_app/themes/app_colors.dart';

NotificationService notificationService = NotificationService();

PreferredSizeWidget homePageAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: context.theme.backgroundColor,
    elevation: 0,
    leading: GestureDetector(
      onTap: () => {
        themeService.switchTheme(),
        notificationService.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode ? "Activated light theme" : "Activated dark theme"),
        // notificationService.scheduledNotification()
      },
      child: Icon(Get.isDarkMode ? Icons.wb_sunny
          : Icons.nightlight_round, size: 23,
        color: Get.isDarkMode ? Colors.white: Colors.black,),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15, top: 17),
        child: FaIcon(FontAwesomeIcons.user, size: 23,
        color: Get.isDarkMode ? whiteColor : blackColor,),
      )
    ],
  );
}