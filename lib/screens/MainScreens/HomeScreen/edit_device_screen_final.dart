import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/config/sizeconfig.dart';
import 'package:smart_home_app/screens/MainScreens/HomeScreen/devicelist.dart';
import 'package:smart_home_app/screens/MainScreens/home_main.dart';
import 'package:smart_home_app/widgets/textfields.dart';
import 'package:http/http.dart' as http;

class EditDeviceScreenFinal extends StatefulWidget {
  final String img, deviceName, deviceID;

  const EditDeviceScreenFinal(
      {Key? key,
      required this.img,
      required this.deviceName,
      required this.deviceID})
      : super(key: key);

  @override
  _EditDeviceScreenFinalState createState() => _EditDeviceScreenFinalState();
}

class _EditDeviceScreenFinalState extends State<EditDeviceScreenFinal> {
  bool visible = true;
  final _editDeviceNamekey = GlobalKey<FormState>();
  FocusNode _deviceNamefocusNode = FocusNode();
  TextEditingController deviceNameController = TextEditingController();

  final deviceNameValidator = MultiValidator([
    RequiredValidator(errorText: "This field is Required*"),
  ]);

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
                height: 320,
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
                              "Edit Device Name",
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
                              child: deviceIcon(widget.img)),
                          Form(
                            key: _editDeviceNamekey,
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
                                child: Visibility(
                                  visible: visible,
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize: 18,
                                        fontFamily: "Poppins",
                                        color: Color(0xffc8bce3)),
                                  ),
                                  replacement: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 17,
                                        height: 17,
                                        child: CircularProgressIndicator(
                                          color: Palette.backgroundColor,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      Text(
                                        " Edit",
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontSize: 18,
                                            fontFamily: "Poppins",
                                            color: Color(0xffc8bce3)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (_editDeviceNamekey.currentState!.validate()) {
                                setState(() {
                                  visible = !visible;
                                });

                                late SharedPreferences preferences;
                                String? accessToken;
                                preferences =
                                    await SharedPreferences.getInstance();
                                accessToken =
                                    preferences.getString('access-token');
                                String editdevicenameurl =
                                    'https://api.iot.puyinfotech.com/api/devices/name';
                                var editres = await http.post(
                                    Uri.parse(editdevicenameurl),
                                    headers: {
                                      'x-access-token': accessToken!,
                                      'Content-Type':
                                          'application/x-www-form-urlencoded'
                                    },
                                    body: {
                                      'id': '${widget.deviceID}',
                                      'name': '${deviceNameController.text}'
                                    });
                                if (editres.statusCode == 200) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/homepage');
                                }
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
