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
import 'package:my_todo_app/widgets/button_widget.dart';
import 'package:my_todo_app/widgets/home_page_app_bar.dart';
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
    print('Notification Received: ${notification.id}');
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
              const SizedBox(height: 10,),
              _taskBar(),
              _datePicker(),
              const SizedBox(height: 15,),
              _showTasks(),
              // _showNoTasks(),
              //_developerInfo(),
            ],),
        ),
      ),
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
            await Get.to(const AddTask()),
            _taskController.getTasks()
          })
        ],),
    );
  }
  _showTasks() {
    return _taskController.taskList.isEmpty ? _showNoTasks() :
      Expanded(child: Obx(() => ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (context, index) {
          Task task = _taskController.taskList[index];
          if(task.repeat == 'Daily') {
            DateTime date = DateFormat.jm().parse(task.startTime.toString());
            var myTime = DateFormat("HH:mm").format(date);
            notificationService.scheduleNotification(
              hour: int.parse(myTime.toString().split(":")[0]),
              minutes: int.parse(myTime.toString().split(":")[1]),
              task: task
            );
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
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
                                              : _bottomButton(
                                              label: 'Task Completed',
                                              onTap: () => {
                                                _taskController.markTaskCompleted
                                                  (task.id!),
                                                Get.back()
                                              }, color: primaryColor,
                                              context: context),
                                          const SizedBox(height: 2),
                                          _bottomButton(
                                              label: 'Delete Task',
                                              onTap: () => {
                                                _taskController.delete(task),
                                                setState(() {}),
                                                Get.back()
                                              },
                                              color: Colors.red[300]!,
                                              context: context),
                                          const SizedBox(height: 10),
                                          _bottomButton(
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
                position: index,
                child: SlideAnimation(
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
                                              : _bottomButton(
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
                                          _bottomButton(
                                              label: 'Delete Task',
                                              onTap: () => {
                                                _taskController.delete(task),
                                                Get.back()
                                              },
                                              color: Colors.red[300]!,
                                              context: context),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          _bottomButton(
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
        })));
  }
  _showNoTasks() {
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
  _developerInfo() {
    return Column(
      children: [
        Text('Developed by Emmy',
        style: GoogleFonts.amita(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1
          )
        ),),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text('+2348140087091',
          style: GoogleFonts.amita(
            textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1
          ),)),
        )
      ],
    );
  }

  _bottomButton({
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
}
