import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/screens/MainScreens/HomeScreen/devicelist.dart';
import 'device_tile.dart';
import 'no_device_found.dart';

class HomeScreen extends StatefulWidget {
  final String? name;
  const HomeScreen({required this.name, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? firstName, accessToken;
  DeviceData getlist = DeviceData();

  Future getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    firstName = preferences.getString('first_name')!;
  }

  void initState() {
    super.initState();
    getUserName();
    getlist.getDeviceList();
  }

  // bool status = false;

  @override
  Widget build(BuildContext context) {
    String? fName = firstName ?? widget.name;
    // getUserName();
    // final devicelist = DeviceData.device_list;
    // final listcount = DeviceData.device_list.length;

    return Container(
      padding: EdgeInsets.only(top: 50, left: 35, right: 35, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi $fName,",
            style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              "Welcome to Home ",
              style: TextStyle(
                fontSize: 15,
                color: Palette.backgroundColor,
                fontFamily: "Poppins",
              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.black26,
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.purple
                    ],
                    stops: [
                      0.0,
                      0.1,
                      0.93,
                      1.0
                    ], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: FutureBuilder(
                  future: getlist.getDeviceList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            // itemCount: listcount,
                            itemCount: snapshot.data.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 17,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.5,
                                    mainAxisExtent: 130.0),
                            itemBuilder: (context, index) =>
                                buildAddDevice(snapshot.data[index], index));
                      } else {
                        return NoDeviceScreen();
                      }
                    } else {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 100,
                          height: 100,
                          child: Container(
                            padding: EdgeInsets.all(35),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Palette.backgroundColor,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
