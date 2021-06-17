import 'package:flutter/material.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/screens/add_device.dart';
import 'package:smart_home_app/screens/homescreen.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int selectedpage = 0;
  final pages = [HomeScreen(), AddDeviceScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      backgroundColor: Palette.backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedpage,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              label: "Add Device"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile")
        ],
        onTap: (int index) {
          setState(() {
            selectedpage = index;
          });
        },
      ),
      body: pages[selectedpage],
    );
  }
}
