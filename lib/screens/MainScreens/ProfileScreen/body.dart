import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_overlay.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "images/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "images/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "images/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "images/Log out.svg",
            press: () {
              OverlayEntry entry =
                  OverlayEntry(builder: (context) => LoadingOverlay());
              Overlay.of(context)!.insert(entry);
              Future.delayed(Duration(milliseconds: 1000), () async {
                entry.remove();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();

                Navigator.pushReplacementNamed(context, '/login');
              });
            },
          ),
        ],
      ),
    );
  }
}
