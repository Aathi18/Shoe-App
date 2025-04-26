import 'package:flutter/material.dart';
import 'package:shoe_app/pages/HomePage.dart';
import 'package:shoe_app/pages/LoginPage.dart';
import 'package:shoe_app/pages/itemPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
          scaffoldBackgroundColor: Color(0xFFCEDDEE)
      ),
      routes: {
        "/" : (context) =>LoginPage(),
        "HomePage" : (context) =>HomePage(),
        "itemPage" : (context) => Itempage()

    },

    );
  }
}
