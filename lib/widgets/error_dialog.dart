import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_home_app/screens/newSignUp.dart';

Future<dynamic> buildShowDialog(
    {bool notAUser = false,
    BuildContext? context,
    String? title,
    String? content}) {
  List<Widget> actions = [
    TextButton(
        onPressed: () {
          Navigator.of(context!).pop();
        },
        child: Text(
          'Try Again',
          style: TextStyle(color: Colors.grey[700]),
        )),
  ];
  if (notAUser) {
    actions.insert(
        1,
        TextButton(
            onPressed: () {
              Navigator.of(context!).pop();
              Navigator.of(context).push(PageTransition(
                  duration: Duration(milliseconds: 800),
                  type: PageTransitionType.fade,
                  child: NewSignUpScreen()));
            },
            child: Text('Sign Up')));
  }
  return showDialog(
    context: context!,
    barrierDismissible: false,
    builder: (BuildContext context) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(title!),
        ),
        content: Text(content!),
        actions: actions),
  );
}

class WifiNotConnectedDialogBox extends StatelessWidget {
  const WifiNotConnectedDialogBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      // backgroundColor: Color(0xff3b4042),
      // contentPadding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
      title: Column(
        children: [
          Icon(
            Icons.wifi,
            color: Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'The Mobile is not connected to Wi-Fi.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 11.0),
        child: Text(
          'Connect Your Mobile Phone to Wi-Fi in order to Add Device.',
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xff616161)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Go To Connect',
          ),
          onPressed: () {
            OpenSettings.openWIFISetting();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
