import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home_app/screens/MainScreens/HomeScreen/devicelist.dart';
import 'package:smart_home_app/models/add_device_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:open_settings/open_settings.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AddDeviceScreenTrial extends StatefulWidget {
  const AddDeviceScreenTrial({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenTrialState createState() => _AddDeviceScreenTrialState();
}

class _AddDeviceScreenTrialState extends State<AddDeviceScreenTrial> {
  String selectedValue = 'Light';
  TextEditingController _textcontroller = TextEditingController();
  var categories = ['Light', 'Fan', 'AC'];

  late StreamSubscription subscription;
  final NetworkInfo _networkInfo = NetworkInfo();
  String _connectionStatus = 'Unknown';

  bool _wifistatus = false;

  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkConnectivity();
    });

    _initNetworkInfo();
  }

  @override
  void dispose() {
    subscription.cancel();

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
          return AlertDialog(
            backgroundColor: Color(0xff3b4042),
            contentPadding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
            title: Column(
              children: [
                Icon(
                  Icons.wifi,
                  color: Colors.teal[300],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'The Mobile is not connected to Wi-Fi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 11.0),
              child: Text(
                'Connect Your Mobile Phone to Wi-Fi in order to Add Device.',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 18, color: Color(0xff80cbc4)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Go To Connect',
                  style: TextStyle(fontSize: 18, color: Color(0xff80cbc4)),
                ),
                onPressed: () {
                  OpenSettings.openWIFISetting();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  checkpermission() async {
    var locationstatus = await Permission.locationWhenInUse.status;
    // print(locationstatus);

    if (!locationstatus.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: selectedValue,
              items: categories
                  .map((String category) => DropdownMenuItem(
                        child: Text(category),
                        value: category,
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
            ),
            TextField(
              controller: _textcontroller,
            ),
            ElevatedButton(
                onPressed: () async {
                  await checkConnectivity();
                  await checkpermission();
                  await _initNetworkInfo();

                  if (_wifistatus) {
                    addAdevice(_textcontroller.text, selectedValue);
                  }
                },
                // onPressed: checkpermission,
                child: Text("Add")),
            Text('$_wifistatus \n $_connectionStatus'),
          ],
        ),
      ),
    );
  }

  void addAdevice(String name, String selectedValue) {
    AddDevice? device;
    if (selectedValue == 'Light') {
      device = AddDevice(
          icon: SvgPicture.asset(
            'images/lightbulb.svg',
            color: Colors.black,
            height: 38,
          ),
          text: name);
    } else if (selectedValue == 'Fan') {
      device = AddDevice(
          icon: SvgPicture.asset(
            'images/Fan.svg',
            color: Colors.black,
            height: 32,
          ),
          text: name);
    } else if (selectedValue == 'AC') {
      device = AddDevice(
          icon: SvgPicture.asset(
            'images/AC.svg',
            color: Colors.black,
            height: 38,
          ),
          text: name);
    }
    setState(() {
      DeviceData.device_list.add(device!);
    });
    _textcontroller.clear();
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
}

// AddDevice a =
//     AddDevice(icon: Icon(Icons.desktop_windows_outlined), text: "For AC");

// void insertdevice() {
//   DeviceData.device_list.insert(DeviceData.device_list.length, a);
//   // key.currentState.insertdevice(DeviceData.device_list.length);
// }

// void removedevice() {
//   DeviceData.device_list.removeAt(DeviceData.device_list.length - 1);
// }
