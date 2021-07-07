import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/screens/MainScreens/home_main.dart';
import 'package:smart_home_app/screens/login.dart';
import 'package:smart_home_app/widgets/error_dialog.dart';
import 'package:smart_home_app/widgets/snack_bar.dart';

class Auth {
  final Map<String, dynamic>? logindetails;
  final Map<String, dynamic>? signupdetails;
  final BuildContext context;

  const Auth({required this.context, this.logindetails, this.signupdetails});

  Future<bool?> loginAPI() async {
    SharedPreferences? preferences;

    String url = "https://api.iot.puyinfotech.com/api/user/login";
    var loginResponse = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: logindetails);
    print(loginResponse.statusCode);
    print(loginResponse.body);
    final data = jsonDecode(loginResponse.body);
    print(data['error']);
    if (loginResponse.statusCode == 200) {
      preferences = await SharedPreferences.getInstance();
      preferences.setString('email', logindetails!['email']);
      preferences.setString('password', logindetails!['password']);
      preferences.setString('access-token', data['accessToken']);

      String? accessToken = preferences.getString('access-token');
      print(accessToken);

      String geturl = "https://api.iot.puyinfotech.com/api/user";
      dynamic userdata = await http.get(
        Uri.parse(geturl),
        headers: {'x-access-token': accessToken!},
      );
      print(userdata.body);
      userdata = jsonDecode(userdata.body);
      String firstname = userdata['first_name'];
      preferences.setString('first_name', firstname);
      print(firstname);

      // final SharedPreferences preferences = await SharedPreferences.getInstance();
      // preferences.setString('accesstoken', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNhZDQ2OTgyLWFhYjQtNDExZi1hYzAzLWI5YmE3MDNkOWM0ZSIsImlhdCI6MTYyNDk4OTQyMiwiZXhwIjoxNjI1MDc1ODIyfQ.oZ8Ou5hMWhpSB14PZTVrBy0l51WLnd1YzsnAQQDPZoo');
      ScaffoldMessenger.of(context).showSnackBar(snackBar('Logged In!!'));

      // Get.offAllNamed('/homepage');
      Get.offAll(HomeMain(
        firstName: firstname,
      ));

      return true;
      // Navigator.of(context).pushReplacementNamed(
      //     '/homepage'
      //     // PageTransition(
      //     //     duration: Duration(
      //     //         milliseconds: 800),
      //     //     type: PageTransitionType.fade,
      //     //     child: return '/homepage')
      //     );
    } else if (loginResponse.statusCode == 401) {
      switch (data['error']) {
        case 'Incorrect Password.':
          await buildShowDialog(
              context: context,
              title: "Incorrect Password",
              content: "Please enter correct password and Try Again.");
          break;

        case 'No user found.':
          await buildShowDialog(
              notAUser: true,
              context: context,
              title: "Incorrect Email",
              content:
                  "The email you entered dosen't appear to belong to and account. Please check your email and try again or Signup to create an account.");

          break;
      }
    }
  }

  Future signUpAPI() async {
    String url = "https://api.iot.puyinfotech.com/api/user/signup";

    var signupResponse = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: signupdetails);
    print(signupResponse.statusCode);
    print(signupResponse.body);
    if (signupResponse.statusCode == 200) {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Successfully SignedUp Yay!!',
          style: TextStyle(color: Palette.homeBGColor),
        ),
        // padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(15),
        backgroundColor: Colors.white,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text("Signed UP"),
            ),
            content: Text("Now you may login with your credentials"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(PageTransition(
                        duration: Duration(milliseconds: 800),
                        type: PageTransitionType.fade,
                        child: Login()));
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Text('Sign Up')),
            ]),
      );
    } else if (signupResponse.statusCode == 500) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text("User already exist"),
            ),
            content: Text(
                "An account with given email already exist. Do you want to Login?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: TextStyle(color: Colors.grey[700]))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(PageTransition(
                        duration: Duration(milliseconds: 800),
                        type: PageTransitionType.fade,
                        child: Login()));
                  },
                  child: Text('Log In'))
            ]),
      );

      // Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
