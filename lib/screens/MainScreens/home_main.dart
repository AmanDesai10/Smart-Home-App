import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/add_device.dart';
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/add_device_trial.dart';
import 'package:smart_home_app/screens/MainScreens/HomeScreen/homescreen.dart';
import 'package:http/http.dart' as http;

import 'ProfileScreen/profile_screen.dart';

class HomeMain extends StatefulWidget {
  final String? firstName;
  const HomeMain({this.firstName, Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int selectedpage = 0;
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        name: widget.firstName,
      ),
      AddDeviceScreen(),
      ProfileScreen()
    ];
    return Scaffold(
      backgroundColor: Color(0xff6930c3),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: selectedpage,
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home_outlined), label: "Home"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.add_circle_outline_rounded),
      //         label: "Add Device"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.person_outline), label: "Profile")
      //   ],
      //   onTap: (int index) {
      //     setState(() {
      //       selectedpage = index;
      //     });
      //   },
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _navKey,
        index: selectedpage,
        color: Palette.backgroundColor,
        backgroundColor: Palette.homeBGColor,
        animationCurve: Curves.easeInOut,
        height: 65,
        animationDuration: Duration(milliseconds: 600),
        items: [
          Icon(
            Icons.home_outlined,
            size: 30,
          ),
          Icon(
            Icons.add_circle_outline_rounded,
            size: 30,
          ),
          Icon(
            Icons.person_outline,
            size: 30,
          )
        ],
        onTap: (int index) {
          if (selectedpage != index) {
            setState(() {
              selectedpage = index;
            });
          }
        },
      ),
      body: pages[selectedpage],
    );
  }
}
