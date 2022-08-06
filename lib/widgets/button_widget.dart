import 'package:flutter/material.dart';
import 'package:my_todo_app/themes/app_colors.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  const MyButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white),));
  }
}
