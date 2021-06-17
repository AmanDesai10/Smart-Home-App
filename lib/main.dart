import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home_app/screens/home_main.dart';
// import 'package:startup_namer/old_screens/login.dart';
import 'package:smart_home_app/screens/login.dart';
import 'package:smart_home_app/screens/newSignUp.dart';
// import 'package:smart_home_app/screens/signup.dart';
// import 'package:smart_home_app/screens/newSignUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xff1B1B1E),
            accentColor: Colors.black,
            primaryColorDark: Colors.grey[350],
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.indigo.shade900),
            ))),
        title: "Smart Home",
        home: HomeMain());
  }
}
