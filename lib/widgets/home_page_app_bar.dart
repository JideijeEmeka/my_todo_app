import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/UI/notified_page.dart';
import 'package:my_todo_app/constants/constants.dart';
import 'package:my_todo_app/main.dart';
import 'package:my_todo_app/services/notification_service.dart';
import 'package:my_todo_app/themes/app_colors.dart';

NotificationService _notificationService = NotificationService();

PreferredSizeWidget homePageAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: context.theme.backgroundColor,
    elevation: 0,
    leading: GestureDetector(
      onTap: () => {
        themeService.switchTheme(),
        /// Show Notification
        _notificationService.showNotification(
          title: "You changed your theme",
          body: Get.isDarkMode ? "Light theme activated!!" : "Dark theme activated!!",
          payload: "You changed your theme"
        ),
        debugPrint('Theme Changed')
        // notificationService.displayNotification(
        //     title: "Theme Changed",
        //     body: Get.isDarkMode ? "Activated light theme" : "Activated dark theme"),
        // notificationService.scheduledNotification()
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 22),
        child: FaIcon(Get.isDarkMode ? FontAwesomeIcons.boltLightning
            : FontAwesomeIcons.powerOff, size: 25,
          color: Get.isDarkMode ? Colors.white: Colors.black,),
      ),
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.only(right: 20, top: 15),
        child: CircleAvatar(
            radius: 19,
            backgroundColor: bluishColor,
            backgroundImage: NetworkImage(profilePicUrl),
        ),
      ),
    ],
  );
}