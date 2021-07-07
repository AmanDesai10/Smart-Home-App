import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_home_app/config/palette.dart';

class NoDeviceScreen extends StatelessWidget {
  const NoDeviceScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            width: 230,
            height: 230,
            child: Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SvgPicture.asset(
                            'images/lightbulb.svg',
                            height: 38,
                          ),
                        ),
                        Expanded(
                            child: Icon(
                          Icons.devices_other_outlined,
                          size: 40,
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No Devices Found',
                      style: TextStyle(
                        color: Palette.backgroundColor,
                        fontFamily: 'Poppins',
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Add your smart device to start using them.',
                      style: TextStyle(
                        color: Palette.backgroundColor,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 120,
          )
        ],
      ),
    );
  }
}
