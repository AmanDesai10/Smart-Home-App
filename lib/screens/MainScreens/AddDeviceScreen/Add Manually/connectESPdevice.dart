import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/config/sizeconfig.dart';
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/Add%20Manually/add_device_name_to_API.dart';
import 'package:smart_home_app/widgets/error_dialog.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ConnectEspDevice extends StatefulWidget {
  final dynamic customurl;
  final String deviceUuid;
  const ConnectEspDevice(
      {Key? key, required this.customurl, required this.deviceUuid})
      : super(key: key);

  @override
  _ConnectEspDeviceState createState() => _ConnectEspDeviceState();
}

class _ConnectEspDeviceState extends State<ConnectEspDevice> {
  String? wifiName, wifiBSSID, wifiIP;

  bool allOk = false;
  late StreamSubscription subscription;
  final NetworkInfo _networkInfo = NetworkInfo();
  String _connectionStatus = "Not Connected to puy_light_";
  bool _wifistatus = false;

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      print(connectivityResult);
      setState(() {
        _wifistatus = true;
        // _connectionStatus = "Connected to puy_light_";
      });
      await checklocationpermission();
      await _initNetworkInfo();

      print(connectivityResult);
    } else {
      setState(() {
        allOk = false;
        _wifistatus = false;
        _connectionStatus =
            "Not Connected to puy_light_\nWi-Fi Name Not verified";
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
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkConnectivity();
    });

    // _initNetworkInfo();

    SizeConfig();
  }

  _initNetworkInfo() async {
    if (_wifistatus) {
      wifiBSSID = await (_networkInfo.getWifiBSSID());
      wifiIP = await (_networkInfo.getWifiIP());
      wifiName = await (_networkInfo.getWifiName());
    }
    if (wifiName == null) {
      buildShowDialog(
          context: context,
          title: 'Not Connected',
          content: 'You are requested to connect to Wi-Fi network puy_light_.');
      setState(() {
        _wifistatus = false;
        allOk = false;
      });
    } else if (wifiName!.length < 10) {
      buildShowDialog(
          context: context,
          title: 'Not Connected',
          content: 'You are requested to connect to Wi-Fi network puy_light_.');
      setState(() {
        _wifistatus = false;
        allOk = false;
      });
    } else if (wifiName!.substring(0, 10) == 'puy_light_') {
      print(wifiName!.substring(0, 9));
      setState(() {
        allOk = true;
        _connectionStatus = 'Connected to puy_light_\nWi-Fi Name Verified';
      });
    } else {
      buildShowDialog(
          context: context,
          title: 'Not Connected',
          content: 'You are requested to connect to Wi-Fi network puy_light_.');
      setState(() {
        _wifistatus = false;
        allOk = false;
      });
    }

    // _connectionStatus = 'Wifi Name: $wifiName\n'
    //     'Wifi BSSID: $wifiBSSID\n'
    //     'Wifi IP: $wifiIP\n';
    // print(_connectionStatus);
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    "Back",
                    style:
                        TextStyle(color: Palette.backgroundColor, fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                height: true ? 580 : 320,
                width: double.infinity,
                margin:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfff5f5f5)),
                child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          Text(
                            "Connect Your Smart Device",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              left: 15,
                              right: 15,
                            ),
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        "You are requested to connect your smartphone's Wifi network to your Smart Device's WiFi named ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.none),
                                  ),
                                  TextSpan(
                                    text: "\"puy_light_\"",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.none),
                                  )
                                ])),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 25, bottom: 20),
                              child: Image(
                                height: SizeConfig.safeBlockVertical * 20,
                                image: AssetImage('images/wifi_reference.png'),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Connection Status: ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(
                                _wifistatus ? Icons.check : Icons.close,
                                color: _wifistatus ? Colors.green : Colors.red,
                                size: 30,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _connectionStatus,
                              style: TextStyle(
                                  color:
                                      _wifistatus ? Colors.green : Colors.red),
                              textAlign: TextAlign.center,
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
                                    "Connect",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: 18,
                                        fontFamily: "Poppins",
                                        color: Color(0xffc8bce3)),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                // await checklocationpermission();
                                // await _initNetworkInfo();
                                await checkConnectivity();

                                try {
                                  if (allOk) {
                                    var connectdeviceres =
                                        await http.get(widget.customurl);

                                    Future.delayed(Duration(seconds: 1), () {
                                      Navigator.of(context)
                                          .popAndPushNamed('/addDeviceName');
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    _connectionStatus =
                                        "Error connecting to device\n Go Back and retry";
                                  });
                                }

                                // print(resbody);
                                print(widget.customurl);
                              }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tip: Location access is required to in order to proceed and auto verify the wifi name.",
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
}
