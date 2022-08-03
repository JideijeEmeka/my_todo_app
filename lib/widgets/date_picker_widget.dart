import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/themes/app_colors.dart';

DateTime _selectedDate = DateTime.now();

datePicker() {
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
        _selectedDate = date;
      },
    ),
  );
}