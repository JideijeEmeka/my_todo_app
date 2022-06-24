import 'package:flutter/material.dart';
import 'package:my_todo_app/services/notification_service.dart';
import 'package:my_todo_app/widgets/home_page_app_bar.dart';

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
      appBar: homePageAppBar(context),
      body: Column(children: [
        Row(children: [
          Column(children: [

          ],)
        ],)
      ],),
    );
  }
}
