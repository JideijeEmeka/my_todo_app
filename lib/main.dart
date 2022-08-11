import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_todo_app/UI/home_page.dart';
import 'package:my_todo_app/database/db_helper.dart';
import 'package:my_todo_app/services/theme_service.dart';
import 'package:my_todo_app/themes/app_theme.dart';

final ThemeService themeService = ThemeService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  await GetStorage().initStorage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: themeService.theme,
      home: const HomePage(),
    );
  }
}
