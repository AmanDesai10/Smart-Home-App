import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/models/add_device_model.dart';
import 'package:http/http.dart' as http;

class DeviceData {
  String? accessToken;

  Future<List<dynamic>> getDeviceList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    accessToken = preferences.getString('access-token');
    print(accessToken);
    print('h');
    String deviceListUrl = "https://api.iot.puyinfotech.com/api/devices";

    var devicelistrequest = await http.get(Uri.parse(deviceListUrl),
        headers: {'x-access-token': '$accessToken'});

    // print(devicelistrequest.body);

    var list = json.decode(devicelistrequest.body);

    return list;
  }

//Delete Below List after completion of project
  static final List<AddDevice> device_list = [
    // AddDevice(icon: deviceIcon(), text: "Living Room Lights"),

    // AddDevice(icon: Icon(Icons.face_unlock_outlined), text: "For Fan"),
    // AddDevice(icon: Icon(Icons.ac_unit_outlined), text: "For AC"),
    // AddDevice(icon: Icon(Icons.desktop_windows_outlined), text: "For AC"),
  ];
}

SvgPicture deviceIcon(String img) {
  return SvgPicture.asset(
    img,
    height: 38,
  );
}
