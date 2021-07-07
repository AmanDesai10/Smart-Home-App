import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/Add%20Manually/add_device_name_to_API.dart';
import 'package:smart_home_app/screens/MainScreens/home_main.dart';
import 'package:smart_home_app/screens/login.dart';
import 'package:smart_home_app/screens/newSignUp.dart';
import 'package:smart_home_app/screens/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_app/widgets/snack_bar.dart';

// import 'package:smart_home_app/screens/signup.dart';
// import 'package:smart_home_app/screens/newSignUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var useremail;
  var firstName;
  bool jwt = false;

  void initState() {
    getPreviousUser().whenComplete(() async {
      Timer(Duration(seconds: 0),
          () => Get.offNamed(jwt ? '/login' : '/homepage'));
    });
    super.initState();
  }

  Future getPreviousUser() async {
    String userinfo = 'https://api.iot.puyinfotech.com/api/user';

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('email');
    var firstName = preferences.getString('first_name');
    var accessToken = preferences.getString('access-token') ?? 'abc';
    print(accessToken);
    setState(() {
      this.useremail = useremail;
      this.firstName = firstName;
    });
    print(useremail);

    var jwtres = await http.get(
      Uri.parse(userinfo),
      headers: {'x-access-token': accessToken},
    );
    if (jwtres.statusCode != 401) {
      setState(() {
        jwt = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // brightness: Brightness.light,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.indigo.shade900),
      ))),
      title: "Smart Home",
      // home: Login(),
      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/signup': (context) => NewSignUpScreen(),
        '/homepage': (context) => HomeMain(
              firstName: firstName,
            ),
        '/addDeviceName': (context) => AddDeviceName(deviceUuid: null),
      },
    );
  }
}
