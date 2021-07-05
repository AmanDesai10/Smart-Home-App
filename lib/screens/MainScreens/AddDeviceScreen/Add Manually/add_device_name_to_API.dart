import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/Add%20Manually/add_manually.dart';

class AddDeviceName extends StatefulWidget {
  final String? deviceUuid;
  const AddDeviceName({Key? key, required this.deviceUuid}) : super(key: key);

  @override
  _AddDeviceNameState createState() => _AddDeviceNameState();
}

class _AddDeviceNameState extends State<AddDeviceName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.homeBGColor,
      body: Container(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/homepage'));
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Palette.backgroundColor, fontSize: 18),
                  textAlign: TextAlign.start,
                ))
          ],
        ),
      ),
    );
  }

  void APIcall() async {
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

    var devicelist = await http.get(Uri.parse(addDeviceUrl),
        headers: {'x-access-token': '$accessToken'});

    print(devicelist.body);
  }
}
