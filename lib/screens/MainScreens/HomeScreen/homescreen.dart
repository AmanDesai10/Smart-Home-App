import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/devicelist.dart';
import 'package:smart_home_app/models/add_device_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String? name;
  const HomeScreen({required this.name, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? firstName;
  Future getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    firstName = preferences.getString('first_name')!;
  }

  void initState() {
    super.initState();
    getUserName();
  }

  // bool status = false;

  @override
  Widget build(BuildContext context) {
    String? fName = firstName ?? widget.name;
    // getUserName();
    final devicelist = DeviceData.device_list;
    final listcount = DeviceData.device_list.length;

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
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: listcount,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 17,
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            mainAxisExtent: 130.0),
                    itemBuilder: (context, index) =>
                        buildAddDevice(devicelist[index], index)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchToggle extends StatefulWidget {
  const SwitchToggle({Key? key}) : super(key: key);

  @override
  _SwitchToggleState createState() => _SwitchToggleState();
}

class _SwitchToggleState extends State<SwitchToggle> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(right: 9.0),
        child: FlutterSwitch(
            height: 28,
            width: 50,
            toggleSize: 22,
            valueFontSize: 13,
            showOnOff: true,
            activeTextColor: Colors.black,
            inactiveTextColor: Colors.blue.shade50,
            activeTextFontWeight: FontWeight.w300,
            inactiveTextFontWeight: FontWeight.w300,
            activeColor: Colors.lightGreenAccent.shade700,
            value: status,
            onToggle: (value) async {
              setState(() {
                status = value;
              });
            }),
      ),
    );
  }
}

Widget buildAddDevice(device, int index) => Devices(device: device);

class Devices extends StatefulWidget {
  final AddDevice? device;

  const Devices({Key? key, @required this.device}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.fromLTRB(25, 15, 25, 15),
      // margin: EdgeInsets.fromLTRB(15, 10, 15, 5),

      decoration: BoxDecoration(
        color: Palette.backgroundColor,
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(width: 2, color: Colors.grey.shade400),
      ),
      // height: 10,
      // width: 50,
      child: Column(
        children: [
          Expanded(
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: widget.device!.icon,
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                  flex: 1,
                ),
                SwitchToggle(),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.device!.text!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ))
        ],
      ),
    );
  }
}
