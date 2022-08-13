import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/themes/app_colors.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? darkGreyColor : whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Get.isDarkMode ? darkGreyColor : whiteColor,
        leading: IconButton(onPressed:
            () =>Get.back(), icon: Icon(Icons.arrow_back_ios,
        color: Get.isDarkMode ? Colors.white : Colors.grey,)),
        title: Text(label.toString().split("|")[0],
          style: TextStyle(
            color:  Get.isDarkMode ? whiteColor : darkGreyColor,),),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.isDarkMode ? darkGreyColor : whiteColor,
          ),
          child: Center(
            child: Text(label.toString().split("|")[0],
              style: TextStyle(
                fontSize: 30,
                color: Get.isDarkMode ? whiteColor : darkGreyColor,),),
          ),
        ),
      ),
    );
  }
}
