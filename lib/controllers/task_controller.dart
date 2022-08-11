import 'package:get/get.dart';
import 'package:my_todo_app/database/db_helper.dart';
import 'package:my_todo_app/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int>? addTask({Task? task}) async {
    return await DbHelper.insert(task);
  }

  /// Get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>>? tasks = await DbHelper.query();
    taskList.assignAll(tasks!.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DbHelper.delete(task);
  }
}