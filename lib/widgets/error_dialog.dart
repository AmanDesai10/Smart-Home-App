import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
