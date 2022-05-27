import 'package:flutter/material.dart';

Widget homePageAppBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () => {},
      child: const Icon(Icons.nightlight_round, size: 20,),
    ),
  );
}