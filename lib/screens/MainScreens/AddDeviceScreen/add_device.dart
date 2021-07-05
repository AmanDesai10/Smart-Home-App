import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home_app/config/palette.dart';

import 'Add Manually/add_manually.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Palette.backgroundColor,
            flexibleSpace: Column(
              children: [
                TabBar(
                  labelColor: Color(0xff6930c3),
                  unselectedLabelColor: Colors.blueGrey[600],
                  tabs: [
                    Tab(
                      text: "Add Manually",
                    ),
                    Tab(
                      text: "Auto Scan",
                    )
                  ],
                  indicatorColor: Color(0xff6930c3),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 40),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [AddManually(), Icon(Icons.ac_unit)]),
        ),
      ),
    );
  }
}
