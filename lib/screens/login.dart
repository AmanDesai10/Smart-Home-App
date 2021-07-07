// import 'package:flutter/gestures.dart';
// import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smart_home_app/screens/MainScreens/home_main.dart';
import 'package:smart_home_app/screens/newSignUp.dart';
import 'package:smart_home_app/screens/signup.dart';
import 'package:smart_home_app/config/sizeconfig.dart';
import 'package:smart_home_app/services/auth.dart';
import 'package:smart_home_app/widgets/snack_bar.dart';
import 'package:smart_home_app/widgets/textfields.dart';
import 'package:smart_home_app/widgets/error_dialog.dart';
// import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String url = "https://api.iot.puyinfotech.com/api/user/login";

  final _formkey = GlobalKey<FormState>();
  // late final SharedPreferences preferences;

  String? email, password;
  bool _isObscure = true;
  final FocusNode focusNode = FocusNode();
  bool visible = true;

  //Controllers

  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  bool isValidated = true;

  //Validators
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "This field is Required*"),
    EmailValidator(errorText: "Please Enter a Valid Email")
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is Required*'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must have at least one special character')
  ]);

  var backgroundImage;
  void initState() {
    super.initState();
    backgroundImage = Image.asset('images/what-is-home-automation.png');
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(backgroundImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("images/what-is-home-automation.png"))),
              )),
          Positioned(
              // top: 200.0,
              top: SizeConfig.blockSizeVertical * 29.3,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 5)
                    ]),
                // height: isValidated ? 300.0 : 335.0,
                height: isValidated
                    ? SizeConfig.blockSizeVertical * 42
                    : SizeConfig.blockSizeVertical * 47,

                width: MediaQuery.of(context).size.width - 50,
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              // fontSize: 30.0,
                              fontSize: (SizeConfig.safeBlockVertical * 5.5),

                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),

                          // height: 3,
                          height: SizeConfig.safeBlockVertical - 4,
                          // width: 45,
                          width: SizeConfig.safeBlockVertical * 9,

                          color: Colors.indigoAccent[200],
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            shrinkWrap: true,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 25, left: 15, right: 15),
                                      child: Textfields(
                                        validate: emailValidator,
                                        controller: controllerEmail,
                                        hintText: "Your Email",
                                        icon: Icons.email_outlined,
                                        isSignupfield: false,
                                      )),
                                  //Password Field
                                  Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Textfields(
                                        focusNode: focusNode,
                                        validate: passwordValidator,
                                        controller: controllerPassword,
                                        hintText: "Enter Password",
                                        icon: Icons.lock_outlined,
                                        suffixIcon: IconButton(
                                            color: Colors.grey,
                                            icon: Icon(_isObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              focusNode.unfocus();
                                              focusNode.canRequestFocus = false;
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            }),
                                        secure: _isObscure,
                                        isSignupfield: false,
                                      )),
                                  GestureDetector(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 10),
                                      // height: 40.0,
                                      height: SizeConfig.safeBlockVertical * 6,
                                      // width: 120.0,
                                      width:
                                          SizeConfig.safeBlockHorizontal * 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          gradient: LinearGradient(
                                              colors: <Color>[
                                                Color(0xff7f29a5),
                                                Color(0xff6742be)
                                              ])
                                          // Decorate here
                                          ),
                                      child: Center(
                                        child: Visibility(
                                            visible: visible,
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  letterSpacing: 2,
                                                  fontSize: 18,
                                                  fontFamily: "Poppins",
                                                  color: Color(0xffc8bce3)),
                                            ),
                                            replacement: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 17,
                                                  height: 17,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        Palette.backgroundColor,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                                Text(
                                                  " Login",
                                                  style: TextStyle(
                                                      letterSpacing: 2,
                                                      fontSize: 18,
                                                      fontFamily: "Poppins",
                                                      color: Color(0xffc8bce3)),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          visible = !visible;
                                        });
                                        isValidated = true;
                                        email = controllerEmail.text;
                                        password = controllerPassword.text;
                                        void remove() {
                                          setState(() {
                                            visible = !visible;
                                          });
                                        }

                                        Map<String, dynamic> logindetails = {
                                          'email': email,
                                          'password': password
                                        };
                                        Auth auth = Auth(
                                            context: context,
                                            logindetails: logindetails);
                                        auth
                                            .loginAPI()
                                            .whenComplete(() => remove());
                                      } else {
                                        setState(() {
                                          isValidated = false;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              )),
          Positioned(
            // top: 560,
            top: SizeConfig.blockSizeVertical * 79,
            left: 10.0,
            right: 20.0,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Palette.textColor1,
                  ),
                ),
                WidgetSpan(
                    child: GestureDetector(
                  child: Text(
                    " SignUp",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      // fontSize: 15.0,
                      color: Color(0xff6742be),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                        duration: Duration(milliseconds: 800),
                        type: PageTransitionType.fade,
                        child: NewSignUpScreen()));
                  },
                ))
              ]),
            ),
          )
        ],
      ),
    );
  }
}
