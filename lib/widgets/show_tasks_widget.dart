import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/controllers/task_controller.dart';

final _taskController = Get.put(TaskController());

showTasks() {
  return Expanded(child: Obx(() => ListView.builder(
      itemCount: _taskController.taskList.length,
      itemBuilder: (context, index) {
        return Container(
            width: 100,
            height: 50,
            color: Colors.greenAccent,
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(_taskController.taskList[index].title!));
      })));
}