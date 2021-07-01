import 'package:flutter/material.dart';
import 'package:smart_home_app/config/palette.dart';

import 'body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.homeBGColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Palette.backgroundColor,
        title: Text(
          "Profile",
          style: TextStyle(color: Palette.homeBGColor),
        ),
      ),
      body: Body(),
    );
  }
}
