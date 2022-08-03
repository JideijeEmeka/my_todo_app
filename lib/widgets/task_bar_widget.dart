import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/UI/add_task_page.dart';
import 'package:my_todo_app/themes/app_theme.dart';
import 'package:my_todo_app/widgets/button_widget.dart';

final DateTime _dateTime = DateTime.now();

taskBar() {
  var formattedDate =  DateFormat.yMMMMd().format(_dateTime);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate, style: subHeadingStyle),
            Text('Today', style: headingStyle)
          ],),
        MyButton(label: '+ Add task', onPressed: () => Get.to(const AddTask()))
      ],),
  );
}