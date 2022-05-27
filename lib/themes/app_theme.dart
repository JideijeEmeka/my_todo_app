import 'package:flutter/material.dart';

import 'app_colors.dart';

class Themes{
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        color: primaryColor));

  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        color: darkGreyColor));
}