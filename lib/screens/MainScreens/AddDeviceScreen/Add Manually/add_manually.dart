import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/screens/MainScreens/AddDeviceScreen/Add%20Manually/users_wifi_info.dart';

class AddManually extends StatelessWidget {
  const AddManually({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.homeBGColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(blurRadius: 15),
                    ],
                    color: Palette.backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35),
                    ))),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              // color: Palette.homeBGColor,
              child: GridView(
                padding: EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  mainAxisExtent: 110.0,
                ),
                children: [
                  DeviceType(
                      deviceType: 'images/lightbulb.svg',
                      deviceTypeName: 'Lights'),
                  DeviceType(deviceType: 'images/AC.svg', deviceTypeName: 'AC'),
                  DeviceType(
                      deviceType: 'images/Fan_v2_1.svg',
                      deviceTypeName: 'Fans'),
                  DeviceType(
                      deviceType: 'images/Bell.svg',
                      deviceTypeName: 'Door Bell'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceType extends StatelessWidget {
  final String deviceType, deviceTypeName;

  const DeviceType({
    Key? key,
    required this.deviceType,
    required this.deviceTypeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return GetUserWifiInfo();
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Palette.backgroundColor,

          borderRadius: BorderRadius.circular(15),
          // border: Border.all(width: 2, color: Colors.grey.shade400),
        ),
        // height: 10,
        // width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: SvgPicture.asset(
                deviceType,
                color: Colors.black,
                height: 38,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                deviceTypeName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
