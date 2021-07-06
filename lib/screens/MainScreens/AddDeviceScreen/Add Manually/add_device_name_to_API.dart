import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/config/sizeconfig.dart';
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/Add%20Manually/connectESPdevice.dart';
import 'package:smart_home_app/widgets/error_dialog.dart';
import 'package:smart_home_app/widgets/textfields.dart';
import 'package:http/http.dart' as http;

class AddDeviceName extends StatefulWidget {
  final String? deviceUuid;

  const AddDeviceName({Key? key, required this.deviceUuid}) : super(key: key);

  @override
  _AddDeviceNameState createState() => _AddDeviceNameState();
}

class _AddDeviceNameState extends State<AddDeviceName> {
  FocusNode _deviceNamefocusNode = FocusNode();

  final TextEditingController deviceNameController = TextEditingController();
  final _deviceNamekey = GlobalKey<FormState>();
  bool isFocus = false;

  final deviceNameValidator = MultiValidator([
    RequiredValidator(errorText: "This field is Required*"),
  ]);

  // late StreamSubscription subscription;

  @override
  void dispose() {
    // subscription.cancel();

    super.dispose();
  }

  void initState() {
    super.initState();
    _deviceNamefocusNode.addListener(onFocus);
  }

  void onFocus() {
    if (!isFocus) {
      setState(() {
        isFocus = !isFocus;
      });
    } else {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          isFocus = !isFocus;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        color: Palette.homeBGColor,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName('/homepage'));
                  },
                  child: Text(
                    "Cancel",
                    style:
                        TextStyle(color: Palette.backgroundColor, fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                height: !isFocus ? 580 : 320,
                width: double.infinity,
                margin:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              "Just one last step",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                            child: Text(
                              'You are almost ready to use your smart device.\nJust Add your preferred device name.',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                            child:
                                CompletedstatusInfo(text: 'Wi-Fi Network Info'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child:
                                CompletedstatusInfo(text: 'Device Connected'),
                          ),
                          Form(
                            key: _deviceNamekey,
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: WifiInputfields(
                                      validate: deviceNameValidator,
                                      controller: deviceNameController,
                                      hintText: "Device Name",
                                      icon: Icons.devices_other,
                                      focusNode: _deviceNamefocusNode,
                                    )),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 25),
                              // height: 40.0,
                              height: SizeConfig.safeBlockVertical * 6,
                              // width: 120.0,
                              width: SizeConfig.safeBlockHorizontal * 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      // Color(0xff6742be).withOpacity(0.8),
                                      Color(0xff7f29a5),
                                      Color(0xff6742be).withOpacity(0.8)
                                    ],
                                  )
                                  // Decorate here
                                  ),
                              child: Center(
                                child: Text(
                                  "Add Device",
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 18,
                                      fontFamily: "Poppins",
                                      color: Color(0xffc8bce3)),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (_deviceNamekey.currentState!.validate()) {
                                callAPI();
                              }
                            },
                          ),
                          // Spacer(),
                          SizedBox(
                            height: isFocus ? 0 : 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                            child: Text(
                              "Tip: Give your device a name such that you can easily recognize your device.",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  void callAPI() async {
    late SharedPreferences preferences;
    String? accessToken;
    preferences = await SharedPreferences.getInstance();
    accessToken = preferences.getString('access-token');
    print(accessToken);
    String addDeviceUrl = "https://api.iot.puyinfotech.com/api/devices";
    var addDeviceResponse = await http.post(Uri.parse(addDeviceUrl), headers: {
      'x-access-token': '$accessToken',
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'id': '${widget.deviceUuid}'
    });

    print(addDeviceResponse.body);
    if (addDeviceResponse.body == 'OK') {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }

    var devicelist = await http.get(Uri.parse(addDeviceUrl),
        headers: {'x-access-token': '$accessToken'});

    print(devicelist.body);
  }
}

class CompletedstatusInfo extends StatelessWidget {
  final String text;
  const CompletedstatusInfo({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black54, fontFamily: 'Poppins', fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green,
            size: 31,
          ),
        )
      ],
    );
  }
}
