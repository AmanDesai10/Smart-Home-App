import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/config/sizeconfig.dart';
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/Add%20Manually/connectESPdevice.dart';
import 'package:smart_home_app/widgets/error_dialog.dart';
import 'package:smart_home_app/widgets/textfields.dart';
import 'package:uuid/uuid.dart';

class GetUserWifiInfo extends StatefulWidget {
  const GetUserWifiInfo({Key? key}) : super(key: key);

  @override
  _GetUserWifiInfoState createState() => _GetUserWifiInfoState();
}

class _GetUserWifiInfoState extends State<GetUserWifiInfo> {
  var customUrl;
  var uuid = Uuid();
  Utf8Encoder utf8 = Utf8Encoder();
  Utf8Decoder utf8d = Utf8Decoder();
  String? userWifiName, userWifiPassword;

  TextEditingController wifiSSID = TextEditingController();
  TextEditingController wifiPassword = TextEditingController();
  final _wifidetailkey = GlobalKey<FormState>();

  FocusNode _wifiNamefocusNode = FocusNode();
  FocusNode _passwordfocusNode = FocusNode();

  bool visible = true;
  bool widgetheight = true;

  final wifiNameValidator = MultiValidator([
    RequiredValidator(errorText: "This field is Required*"),
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: "This field is Required*"),
  ]);

  // late StreamSubscription subscription;
  final NetworkInfo _networkInfo = NetworkInfo();
  String _connectionStatus = 'Unknown';

  bool _wifistatus = false;

  @override
  void dispose() {
    // subscription.cancel();

    super.dispose();
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _wifistatus = true;
      });
      print(connectivityResult);
    } else {
      setState(() {
        _wifistatus = false;
      });
      print('Not connected');
      await _isWifiOn();
    }
  }

  Future<void> _isWifiOn() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WifiNotConnectedDialogBox();
        });
  }

  checklocationpermission() async {
    var locationstatus = await Permission.locationWhenInUse.status;
    // print(locationstatus);

    if (!locationstatus.isGranted) {
      await Permission.location.request();
      await Permission.locationWhenInUse.serviceStatus.isEnabled;
    } else if (locationstatus.isGranted) {}
  }

  void initState() {
    super.initState();
    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   checkConnectivity();
    // });

    _initNetworkInfo();
    _wifiNamefocusNode.addListener(onFocus);
    _passwordfocusNode.addListener(onFocus);
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName, wifiBSSID, wifiIP;
    if (_wifistatus) {
      wifiBSSID = await (_networkInfo.getWifiBSSID());
      wifiIP = await (NetworkInfo().getWifiIP());
      wifiName = await (NetworkInfo().getWifiName());
    }
    setState(() {
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IP: $wifiIP\n';
    });
  }

  void onFocus() {
    setState(() {
      widgetheight = !widgetheight;
      Future.delayed(Duration(milliseconds: 50), () {
        visible = !visible;
      });
    });
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
                    Navigator.pop(context);
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
                height: visible ? 580 : 320,
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
                          Text(
                            "Select 2.4 GHz Wi-Fi Network and enter password.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 15,
                              right: 15,
                            ),
                            child: Text(
                              "If your Wi-Fi is 5 GHz, please set it to be 2.4 Ghz.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w300,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          Visibility(
                            visible: visible,
                            child: Container(
                                margin: EdgeInsets.only(top: 25),
                                child: Image(
                                  height: SizeConfig.safeBlockVertical * 20,
                                  image: AssetImage('images/wifi_config.jpg'),
                                )),
                          ),
                          Form(
                            key: _wifidetailkey,
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 25),
                                    child: WifiInputfields(
                                      validate: wifiNameValidator,
                                      controller: wifiSSID,
                                      hintText: "Wi-Fi Name",
                                      icon: Icons.wifi,
                                      focusNode: _wifiNamefocusNode,
                                    )),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: WifiInputfields(
                                      validate: passwordValidator,
                                      controller: wifiPassword,
                                      hintText: "Password",
                                      icon: Icons.lock_outlined,
                                      focusNode: _passwordfocusNode,
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
                                  "Next",
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 18,
                                      fontFamily: "Poppins",
                                      color: Color(0xffc8bce3)),
                                ),
                              ),
                            ),
                            onTap: () async {
                              // await checkConnectivity();
                              // await checklocationpermission();
                              // _initNetworkInfo();
                              if (_wifidetailkey.currentState!.validate()) {
                                userWifiName = wifiSSID.text;
                                userWifiPassword = wifiPassword.text;
                                String deviceUuid = uuid.v4();

                                customUrl =
                                    Uri.http('192.168.4.1', "/setting", {
                                  'ssid': '$userWifiName',
                                  'pass': '$userWifiPassword',
                                  'uuid': '$deviceUuid',
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ConnectEspDevice(
                                    customurl: customUrl,
                                    deviceUuid: deviceUuid,
                                  );
                                }));

                                // print('Get Request URL: $customUrl');
                              }
                            },
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
}
