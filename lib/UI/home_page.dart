import 'package:flutter/material.dart';
import 'package:my_todo_app/widgets/home_page_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageAppBar(),
      body: Column(children: const [
        Text("emmy")
      ],),
    );
  }
}
