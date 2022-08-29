import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/themes/app_colors.dart';
import 'package:my_todo_app/themes/app_theme.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: bluishColor,
        leading: IconButton(onPressed:
            () =>Get.back(), icon: Icon(Icons.arrow_back_ios,
        size: 21,
        color: Get.isDarkMode ? Colors.white : whiteColor,)),
        title: Text(label.toString().split("|")[0],),
        titleTextStyle: GoogleFonts.lato(textStyle:
        TextStyle(color:  Get.isDarkMode ? whiteColor : whiteColor,
          fontSize: 20
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 1),
              child: Text('Hello, Emmy', style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode ? whiteColor : blackColor
                  )
              ),),
            ),
            Text('You have a new reminder', style: subHeadingStyle,),
            Container(
              margin: const EdgeInsets.only(left: 30,
                  right: 30, top: 30, bottom: 50),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: bluishColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.bookOpen,
                            size: 35, color: whiteColor,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Title', style: GoogleFonts.lato(textStyle:
                              const TextStyle(color: whiteColor, fontSize: 20)),),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(label.toString().split("|")[0],
                            style: TextStyle(
                              fontSize: 17,
                              color: whiteColor.withOpacity(0.7),),),
                      ),
                      /// Description
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.listCheck, size: 35, color: whiteColor,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Description', style: GoogleFonts.lato(textStyle:
                            const TextStyle(color: whiteColor, fontSize: 20)),),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(label.toString().split("|")[1],
                          style: TextStyle(
                            fontSize: 17,
                            color: whiteColor.withOpacity(0.7),),),
                      ),
                      /// Date
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.calendarCheck, size: 35, color: whiteColor,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Date', style: GoogleFonts.lato(textStyle:
                            const TextStyle(color: whiteColor, fontSize: 20)),),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(label.toString().split("|")[2],
                          style: TextStyle(
                            fontSize: 17,
                            color: whiteColor.withOpacity(0.7),),),
                      ),
                      /// Time
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.clock, size: 35, color: whiteColor,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Time', style: GoogleFonts.lato(textStyle:
                            const TextStyle(color: whiteColor, fontSize: 20)),),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(label.toString().split("|")[3],
                          style: TextStyle(
                            fontSize: 17,
                            color: whiteColor.withOpacity(0.7),),),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
