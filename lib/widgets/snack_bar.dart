import 'package:flutter/material.dart';
import 'package:smart_home_app/config/palette.dart';

SnackBar snackBar(String text) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(color: Palette.homeBGColor),
    ),
    // padding: EdgeInsets.all(10),
    margin: EdgeInsets.all(15),
    backgroundColor: Colors.white,
  );
}
