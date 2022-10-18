import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/themes/app_colors.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBackgroundColor(task.color??0),
        ),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title??"", style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),),
              const SizedBox(height: 12,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_rounded,
                    color: Colors.grey[200],
                    size: 18,),
                  const SizedBox(width: 4,),
                  Text('${task.startTime} - ${task.endTime}',
                  style: GoogleFonts.lato(fontSize: 13,
                  color: Colors.grey[100]),),
                ],
              ),
              const SizedBox(height: 12,),
              Text(task.note??"", style: GoogleFonts.lato(
                fontSize: 13, color: Colors.grey[100]
              ),)
            ],)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(quarterTurns: 3,
            child: Text(task.isCompleted == 1 ? "COMPLETED" : "TODO",
            style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),)
          ],
        ),
      ),
    );
  }

  _getBackgroundColor(int no) {
     switch (no) {
       case 0:
         return bluishColor;
       case 1:
         return pinkishColor;
       case 2:
         return yellowishColor;
       case 3:
         return blackColor;
       case 4:
         return purpleColor;
       default:
         return bluishColor;
     }
  }
}
