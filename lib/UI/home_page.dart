import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/UI/add_task_page.dart';
import 'package:my_todo_app/UI/notified_page.dart';
import 'package:my_todo_app/controllers/task_controller.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/services/notification_service.dart';
import 'package:my_todo_app/themes/app_colors.dart';
import 'package:my_todo_app/themes/app_theme.dart';
import 'package:my_todo_app/widgets/bottom_button_widget.dart';
import 'package:my_todo_app/widgets/button_widget.dart';
import 'package:my_todo_app/widgets/home_page_app_bar.dart';
import 'package:my_todo_app/widgets/show_no_tasks.dart';
import 'package:my_todo_app/widgets/task_tile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late NotificationService notificationService;
  late DateTime _selectedDate;
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    notificationService.init();
    notificationService.setOnNotificationReceive(onNotificationReceive);
    notificationService.setOnNotificationClick(onNotificationClick);
    _selectedDate = DateTime.now();
  }

  onNotificationReceive(ReceiveNotification notification) {
    debugPrint('Notification Received: ${notification.id}');
  }

  onNotificationClick(String? payload) {
    if(payload != null && payload == "You changed your theme") {
      debugPrint("Notification payload: $payload");
      debugPrint('Nothing to navigate');
    }else {
      Get.to(NotifiedPage(label: payload));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: homePageAppBar(context),
      body: Column(children: [
              const SizedBox(height: 10,),
              _taskBar(),
              _datePicker(),
              const SizedBox(height: 15),
            Expanded(child: Obx(() => _showTasks())),
          const SizedBox(height: 30,)
            ],),
    );
  }

  _datePicker() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        selectedTextColor: whiteColor,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 20,
            )
        ),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 16,
            )
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 14,
            )
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
  _taskBar() {
    var formattedDate =  DateFormat.yMMMMd().format(_selectedDate);
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
          MyButton(label: '+ Add task', onPressed: () async =>
          {
            await Get.to(() => const AddTask()),
            _taskController.getTasks()
          })
        ],),
    );
  }
  _showTasks() {
    return _taskController.taskList.isEmpty ? showNoTasks() :
    SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            Task task = _taskController.taskList[index];
            if(task.repeat == 'Daily') {
              DateTime date = DateFormat.jm().parse(task.startTime!.trim());
              var myTime = DateFormat("HH:mm").format(date);
              notificationService.scheduleNotification(
                  hour: int.parse(myTime.trim().toString().split(":")[0]),
                  minutes: int.parse(myTime.trim().toString().split(":")[1]),
                  task: task
              );
              return
                  AnimationConfiguration.staggeredList(
                      duration: const Duration(seconds: 2),
                      delay: const Duration(milliseconds: 500),
                      position: index,
                      child: SlideAnimation(
                          //horizontalOffset: 70,
                          verticalOffset: 50,
                          child: FadeInAnimation(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                        Container(
                                          padding: const EdgeInsets.only(top: 1),
                                          height: task.isCompleted == 1
                                              ? MediaQuery.of(context).size.height * 0.30
                                              : MediaQuery.of(context).size.height * 0.37,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                            ),
                                            color: Get.isDarkMode ? darkGreyColor : whiteColor,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 6, width: 120,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Get.isDarkMode ? Colors.grey[600]
                                                          : Colors.grey[300])),
                                              const SizedBox(height: 20),
                                              task.isCompleted == 1 ? Container()
                                                  : bottomButton(
                                                  label: 'Task Completed',
                                                  onTap: () => {
                                                    _taskController.markTaskCompleted
                                                      (task.id!),
                                                    Get.back()
                                                  }, color: primaryColor,
                                                  context: context),
                                              const SizedBox(height: 2),
                                              bottomButton(
                                                  label: 'Delete Task',
                                                  onTap: () => {
                                                    _taskController.delete(task),
                                                    Get.back(),
                                                    Get.to(() => const HomePage()),
                                                    setState(() {}),
                                                  },
                                                  color: Colors.red[300]!,
                                                  context: context),
                                              const SizedBox(height: 10),
                                              bottomButton(
                                                  label: 'Close',
                                                  onTap: () => Get.back(),
                                                  color: Colors.red[300]!,
                                                  isClosed: true,
                                                  context: context),
                                              const SizedBox(
                                                height: 15,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: TaskTile(task: task),
                                  )
                                ],
                              ))));
            }
            if(task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                  duration: const Duration(seconds: 2),
                  delay: const Duration(milliseconds: 500),
                  position: index,
                  child: SlideAnimation(
                     verticalOffset: 50,
                       //horizontalOffset: 70,
                      child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                      Container(
                                        padding: const EdgeInsets.only(top: 4),
                                        height: task.isCompleted == 1
                                            ? MediaQuery.of(context).size.height * 0.25
                                            : MediaQuery.of(context).size.height * 0.35,
                                        color: Get.isDarkMode ? darkGreyColor : whiteColor,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 6,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]
                                              ),
                                            ),
                                            const Spacer(),
                                            task.isCompleted == 1 ? Container()
                                                : bottomButton(
                                                label: 'Task Completed',
                                                onTap: () => {
                                                  _taskController.markTaskCompleted
                                                    (task.id!),
                                                  Get.back()
                                                }, color: primaryColor,
                                                context: context),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            bottomButton(
                                                label: 'Delete Task',
                                                onTap: () => {
                                                  _taskController.delete(task),
                                                  Get.back(),
                                                  Get.to(() => const HomePage()),
                                                  setState(() {}),
                                                },
                                                color: Colors.red[300]!,
                                                context: context),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            bottomButton(
                                                label: 'Close',
                                                onTap: () => {
                                                  Get.back()
                                                }, color: Colors.red[300]!,
                                                isClosed: true,
                                                context: context),
                                            const SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        ),
                                      ));
                                },
                                child: TaskTile(task: task),
                              )
                            ],
                          ))));
            } else {
              return Container();
            }
          }),
    );
  }
}
