import 'package:flutter/material.dart';
import 'package:smart_home_app/devicelist.dart';
import 'package:smart_home_app/models/add_device_model.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(children: [
        ElevatedButton(
          child: Text("Insert"),
          onPressed: () {
            insertdevice();
          },
        ),
        ElevatedButton(
          child: Text("Remove"),
          onPressed: () {
            removedevice();
          },
        ),
      ]),
    );
  }
}

AddDevice a =
    AddDevice(icon: Icon(Icons.desktop_windows_outlined), text: "For AC");

void insertdevice() {
  DeviceData.device_list.insert(DeviceData.device_list.length, a);
  // key.currentState.insertdevice(DeviceData.device_list.length);
}

void removedevice() {
  DeviceData.device_list.removeAt(DeviceData.device_list.length - 1);
}
