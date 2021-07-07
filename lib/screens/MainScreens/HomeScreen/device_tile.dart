import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/widgets/snack_bar.dart';
import 'package:http/http.dart' as http;

import 'devicelist.dart';

Widget buildAddDevice(device, int index) => Devices(device: device);

class Devices extends StatelessWidget {
  final dynamic device;

  const Devices({Key? key, @required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeviceTile(
      status: device['state'],
      deviceID: device['id'],
      deviceType: device['type'],
    );
  }
}

class DeviceTile extends StatefulWidget {
  bool status;
  final String deviceID;
  final String deviceType;

  DeviceTile(
      {Key? key,
      required this.status,
      required this.deviceID,
      required this.deviceType})
      : super(key: key);

  @override
  _DeviceTileState createState() => _DeviceTileState();
}

class _DeviceTileState extends State<DeviceTile> {
  @override
  Widget build(BuildContext context) {
    // bool status = widget.device['state'];
    // String deviceID = widget.device['id'];
    String deviceTilestate = !widget.status ? 'on' : 'off';
    String img =
        widget.status ? 'images/lightbulb-on.svg' : 'images/lightbulb.svg';
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
                      padding: EdgeInsets.only(top: 5), child: deviceIcon(img)),
                ),
                Expanded(
                  child: SizedBox(),
                  flex: 1,
                ),
                // SwitchToggle(
                //   deviceID: widget.device['id'],
                //   status: widget.device['state'],
                // ),
                Expanded(
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
                        value: widget.status,
                        onToggle: (value) async {
                          setState(() {
                            widget.status = value;
                          });

                          try {
                            String statechangeurl =
                                "https://api.iot.puyinfotech.com/api/devices/${widget.deviceID}/$deviceTilestate";
                            print(statechangeurl);

                            String accessToken;
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            accessToken =
                                preferences.getString('access-token')!;

                            var devicestatechangeres = await http.get(
                                Uri.parse(statechangeurl),
                                headers: {'x-access-token': accessToken});
                            // print(devicestatechangeres.body);

                            if (devicestatechangeres.statusCode != 200) {
                              setState(() {
                                widget.status = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar('Device Failed to Respond :('));
                            }
                          } catch (e) {
                            setState(() {
                              widget.status = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar('No internet!!'));
                          }

                          // print(widget.deviceID);
                        }),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.deviceType,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ))
        ],
      ),
    );
  }
}
