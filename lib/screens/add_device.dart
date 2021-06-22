import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home_app/devicelist.dart';
import 'package:smart_home_app/models/add_device_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:open_settings/open_settings.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  String selectedValue = 'Light';
  TextEditingController _textcontroller = TextEditingController();
  var categories = ['Light', 'Fan', 'AC'];

  late StreamSubscription subscription;

  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkConnectivity();
    });
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  bool trial = false;
  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        trial = true;
      });
      print(connectivityResult);
    } else {
      setState(() {
        trial = false;
      });
      await _isWifiOn();
      print('Not connected');
    }
  }

  Future<void> _isWifiOn() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Turn On WiFi'),
            content: Text('You are requested to Turn On Your Wifi'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  OpenSettings.openWIFISetting();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // checkpermission() async {
  //   var locationstatus = await Permission.locationWhenInUse.status;
  //   // print(locationstatus);

  //   if (!locationstatus.isGranted) {
  //     await Permission.location.request();
  //   }
  // }

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
                onPressed: () {
                  // _checkPermission();
                  checkConnectivity();
                  if (trial) {
                    addAdevice(_textcontroller.text, selectedValue);
                  }
                },
                // onPressed: checkpermission,
                child: Text("Add")),
            Text('$trial'),
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
