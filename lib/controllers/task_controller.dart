import 'package:get/get.dart';
import 'package:my_todo_app/database/db_helper.dart';
import 'package:my_todo_app/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<int>? addTask({Task? task}) async {
    return await DbHelper.insert(task);
  }
}