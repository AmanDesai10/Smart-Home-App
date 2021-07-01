import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home_app/config/palette.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          CircleAvatar(
            backgroundColor: Palette.backgroundColor,
            backgroundImage: AssetImage("images/profile pic.jpg"),
          ),
        ],
      ),
    );
  }
}
