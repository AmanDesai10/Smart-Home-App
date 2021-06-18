import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:smart_home_app/models/add_device_model.dart';

class DeviceData {
  static final List<AddDevice> device_list = [
    AddDevice(icon: deviceIcon(), text: "Living Room Lights"),
    AddDevice(icon: Icon(Icons.face_unlock_outlined), text: "For Fan"),
    AddDevice(icon: Icon(Icons.ac_unit_outlined), text: "For AC"),
    AddDevice(icon: Icon(Icons.desktop_windows_outlined), text: "For AC"),
  ];
}

Icon deviceIcon() {
  return Icon(
    Icons.lightbulb_outline,
    size: 40,
  );
}
