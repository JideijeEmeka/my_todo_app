import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/UI/notified_page.dart';
import 'package:my_todo_app/constants/constants.dart';
import 'package:my_todo_app/main.dart';
import 'package:my_todo_app/services/notification_service1.dart';
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
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 22),
        child: FaIcon(Get.isDarkMode ? FontAwesomeIcons.boltLightning
            : FontAwesomeIcons.powerOff, size: 25,
          color: Get.isDarkMode ? Colors.white: Colors.black,),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20, top: 15),
        child: InkWell(
          onTap: () => Get.to(const NotifiedPage(label: 'label')),
          child: const CircleAvatar(
            radius: 19,
            backgroundColor: bluishColor,
            backgroundImage: NetworkImage(profilePicUrl),
          ),
        ),
      ),
    ],
  );
}