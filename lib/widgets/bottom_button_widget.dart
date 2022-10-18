import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/themes/app_theme.dart';

Widget bottomButton({
    required String label,
    required Function() onTap,
    required Color color,
    bool isClosed = false,
    required BuildContext context
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: isClosed == true ? Colors.transparent : color,
            border: Border.all(
              width: 2,
              color: isClosed == true ? Get.isDarkMode ? Colors.grey[600]!
                  : Colors.grey[300]! : color,
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(child:
        Text(label, style: isClosed ? titleStyle : titleStyle.copyWith(color: Colors.white),)),
      ),
    );
}