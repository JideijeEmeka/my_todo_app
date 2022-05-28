import 'package:flutter/material.dart';
import 'package:my_todo_app/main.dart';

PreferredSizeWidget homePageAppBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () => themeService.switchTheme(),
      child: const Icon(Icons.nightlight_round, size: 20,),
    ),
    actions: const [
      Icon(Icons.person, size: 20,)
    ],
  );
}