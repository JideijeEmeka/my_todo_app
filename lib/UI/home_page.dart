import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/services/notification_service.dart';
import 'package:my_todo_app/widgets/date_picker_widget.dart';
import 'package:my_todo_app/widgets/home_page_app_bar.dart';
import 'package:my_todo_app/widgets/show_tasks_widget.dart';
import 'package:my_todo_app/widgets/task_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    notificationService.initializeNotification();
    notificationService.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: homePageAppBar(context),
      body: Column(children: [
        taskBar(),
        datePicker(),
        const SizedBox(height: 10,),
        showTasks(),
      ],),
    );
  }
}
