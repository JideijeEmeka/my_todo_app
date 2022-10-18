import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/themes/app_colors.dart';

Widget showNoTasks() {
  return Padding(
    padding: const EdgeInsets.only(top: 200),
    child: Column(
      children: [
        Icon(Icons.task, size: 80,
          color: Get.isDarkMode ? bluishColor.withOpacity(0.8) : bluishColor,),
        Text('You do not have any tasks yet!',
          style: GoogleFonts.portLligatSlab(textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
          )),),
        Text('Add new tasks to make your days productive.',
          style: GoogleFonts.portLligatSlab(textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
          )),)
      ],
    ),
  );
}