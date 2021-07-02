import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home_app/config/palette.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Palette.backgroundColor,
            flexibleSpace: Column(
              children: [
                TabBar(
                  labelColor: Color(0xff6930c3),
                  unselectedLabelColor: Colors.blueGrey[600],
                  tabs: [
                    Tab(
                      text: "Add Manually",
                    ),
                    Tab(
                      text: "Auto Scan",
                    )
                  ],
                  indicatorColor: Color(0xff6930c3),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 40),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            Container(
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                          DeviceType(
                              deviceType: 'images/AC.svg',
                              deviceTypeName: 'AC'),
                          DeviceType(
                              deviceType: 'images/Fan_v2.svg',
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
            ),
            Icon(Icons.ac_unit)
          ]),
        ),
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
        // Navigator.of(context).pushNamed('/signup');
      },
      child: Container(
        // margin: EdgeInsets.all(10),
        // height: 10,
        // width: 200,
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
