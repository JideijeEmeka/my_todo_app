import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/constants/constants.dart';
import 'package:my_todo_app/controllers/task_controller.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/themes/app_colors.dart';
import 'package:my_todo_app/themes/app_theme.dart';
import 'package:my_todo_app/widgets/button_widget.dart';
import 'package:my_todo_app/widgets/input_field.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TaskController _taskController = Get.put(TaskController());
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = '9:30PM';
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20
  ];

  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly'
  ];

  int _selectedColor = 0;
  bool isLoading = false;

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    if(_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        debugPrint('$_selectedDate');
      });
    }else {
      debugPrint('Something is not right');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String formattedTime = pickedTime.format(context);
    if(isStartTime == true) {
      setState(() {
        _startTime = formattedTime;
      });
    }else if(isStartTime == false) {
      setState(() {
        _endTime = formattedTime;
      });
    }else if(pickedTime == null) {
      debugPrint('Time Cancelled');
    }
  }

  _showTimePicker() {
    return showTimePicker(context: context,
        builder: (context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(':')[0]),
            minute: int.parse(_startTime.split(':')[1].split(' ')[0])));
  }

  _validateDate() {
    if(titleController.text.isNotEmpty
        && noteController.text.isNotEmpty) {
      /// Add to database
      setState(() {
        isLoading = true;
      });
      Future.delayed(const Duration(seconds: 1), () => {
        _addTaskToDatabase(),
        _taskController.getTasks(),
        _taskController.update(),
        setState(() {}),
      }).then((value) => {
        setState(() {
          isLoading = false;
        }),
      Get.back(),
      });
    }else {
      if(titleController.text.isEmpty
          || noteController.text.isEmpty) {
        Get.snackbar('Required', 'All fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: whiteColor,
        colorText: pinkishColor,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red,));
      }
    }
  }

  _addTaskToDatabase() async {
    int? value = await _taskController.addTask(
      task: Task(
          title: titleController.text,
          note: noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat
      )
    );
    debugPrint('My id is: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        leading: IconButton(onPressed: () => Get.back(),
            padding: const EdgeInsets.only(left: 10, top: 10),
            icon: const FaIcon(FontAwesomeIcons.backward, size: 23,
              color: bluishColor,)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20, top: 15),
            child: CircleAvatar(
                radius: 19,
                backgroundColor: bluishColor,
                backgroundImage: NetworkImage(profilePicUrl),
              ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Text('Add Task', style: headingStyle,),
              MyInputField(hint: 'Enter title here.', title: 'Title',
                controller: titleController,),
              MyInputField(hint: 'Enter your note here.', title: 'Note',
                controller: noteController,),
              MyInputField(hint: DateFormat.yMd().format(_selectedDate), title: 'Date',
                widget: IconButton(onPressed: () {
                  _getDateFromUser();
                },
                    icon: const Icon(Icons.calendar_today_outlined, color: Colors.grey,)),),
              Row(
                children: [
                  Expanded(child: MyInputField(hint: _startTime, title: 'Start Date',
                  widget: IconButton(onPressed: () {
                    _getTimeFromUser(isStartTime: true);
                  }, icon: const Icon(Icons.access_time_rounded,
                  color: Colors.grey,)),)),
                  const SizedBox(width: 12,),
                  Expanded(child: MyInputField(hint: _endTime, title: 'End Date',
                  widget: IconButton(onPressed: () {
                    _getTimeFromUser(isStartTime: false);
                  }, icon: const Icon(Icons.access_time_rounded,
                  color: Colors.grey,)),))
                ],
              ),
              MyInputField(hint: '$_selectedRemind minutes early', title: 'Remind',
              widget: DropdownButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey,),
                elevation: 4,
                iconSize: 32,
                style: subTitleStyle,
                items: remindList.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()), 
                  );
                }).toList(),
                underline: Container(height: 0,),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
              ),),
              MyInputField(hint: _selectedRepeat, title: 'Repeat',
              widget: DropdownButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey,),
                elevation: 4,
                iconSize: 32,
                style: subTitleStyle,
                items: repeatList.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!, style: const TextStyle(color: Colors.grey),),
                  );
                }).toList(),
                underline: Container(height: 0,),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
              ),),
              const SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallet(),
                  isLoading ? const SizedBox(height: 30, width: 30,
                      child: CircularProgressIndicator()) :
                  MyButton(label: 'Create Task', onPressed: () => {
                    _validateDate(),
                    // Get.to(const NotifiedPage(label: 'Obi'));
                  })
                ],
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
  _colorPallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle,),
        const SizedBox(height: 8,),
        Wrap(
          children: List<Widget>.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
                debugPrint('$index');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0 ? primaryColor
                      : index == 1 ? pinkishColor
                      : yellowishColor,
                  child: _selectedColor == index ? const Icon(Icons.done, size: 16,
                    color: whiteColor,) : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
