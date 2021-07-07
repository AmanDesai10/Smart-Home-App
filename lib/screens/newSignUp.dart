import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:math' as math;
import 'package:smart_home_app/config/palette.dart';
import 'package:smart_home_app/config/sizeconfig.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home_app/services/auth.dart';
import 'package:smart_home_app/widgets/textfields.dart';

class NewSignUpScreen extends StatefulWidget {
  const NewSignUpScreen({Key? key}) : super(key: key);

  @override
  _NewSignUpScreenState createState() => _NewSignUpScreenState();
}

class _NewSignUpScreenState extends State<NewSignUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _animationController, _zoominoutController;
  late Animation<double> _zoominout;

  final _formkey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  String? email, password, firstName, lastName;
  bool _isObscure = true, visible = true;

  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();

  bool isValidated = true;
  // bool ispasswordtapped = false, isconfirmpassTapped = false;

  //Validators
  final nameValidator = MultiValidator([
    RequiredValidator(errorText: "This Field is Required*"),
  ]);
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "This field is Required*"),
    EmailValidator(errorText: "Please Enter a Valid Email")
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is Required*'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character')
  ]);

  bool disposed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
      // reverseDuration: Duration(seconds: 2),
    )..forward();

    _controller.addStatusListener((status) {
      if (disposed == true) return;

      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 0), () {
          _controller.reverse();
        });
      } else if (disposed == true)
        return;
      else if (status == AnimationStatus.dismissed) {
        Future.delayed(Duration(milliseconds: 500), () {
          _controller.forward();
        });
      }
    });

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    _animationController.repeat(reverse: true);

    _zoominoutController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.3);

    _zoominout = CurvedAnimation(
        parent: _zoominoutController, curve: Curves.easeInOutBack);

    _zoominoutController.forward();
    _zoominoutController.addStatusListener((status) {
      if (disposed == true) return;
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 1000), () {
          _zoominoutController.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(Duration(milliseconds: 500), () {
          _zoominoutController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    disposed = true;
    _controller.dispose();
    _animationController.dispose();
    _zoominoutController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(
        // alignment: Alignment.center,
        children: [
          Positioned(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Color(0xff87219e),
                  Color(0xff6049c5),
                  Color(0xff4edfd5)
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
              ),
            ),
          ),
          Positioned(
            // top: 70,
            top: SizeConfig.safeBlockVertical * 10,
            left: 0,
            right: 0,
            child: Text(
              "SignUp",
              style: TextStyle(
                  color: Colors.grey.shade50.withOpacity(0.9),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  fontSize: SizeConfig.safeBlockVertical * 6.6,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            // top: 125,
            top: SizeConfig.safeBlockVertical * 18.3,
            // left: 270,
            left: MediaQuery.of(context).size.width - 90,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Image.asset(
                'images/download.png',
                // width: 50,
                width: SizeConfig.safeBlockHorizontal * 13,
                // height: 50,
                height: SizeConfig.safeBlockVertical * 8,
                color: Colors.grey.shade200.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
              // top: 470,
              top: SizeConfig.safeBlockVertical * 69,
              left: 20,
              // left: MediaQuery.of(context).size.width - 340,
              child: Image.asset(
                "images/outline_lightbulb_black_24dp.png",
                // width: 50,
                width: SizeConfig.safeBlockHorizontal * 13,
                // height: 50,
                height: SizeConfig.safeBlockVertical * 8,
                color: Colors.grey.shade200.withOpacity(0.3),
              )),
          Positioned(
            // top: 470,
            top: SizeConfig.safeBlockVertical * 69,
            left: 20,
            // left: MediaQuery.of(context).size.width - 340,

            child: FadeTransition(
              opacity: _animationController,
              child: Image.asset(
                "images/outline_lightbulb_black_24dp.png",
                // width: 50,
                width: SizeConfig.safeBlockHorizontal * 13,
                // height: 50,
                height: SizeConfig.safeBlockVertical * 8,
                color: Colors.yellow.withOpacity(0.7),
              ),
            ),
          ),

          Positioned(
            // top: 500,
            top: SizeConfig.safeBlockVertical * 73,
            // left: 280,
            left: MediaQuery.of(context).size.width - 85,
            child: ScaleTransition(
              scale: _zoominout,
              child: Image.asset(
                "images/car_garage.png",
                // width: 50,
                width: SizeConfig.safeBlockHorizontal * 13,
                // height: 50,
                height: SizeConfig.safeBlockVertical * 8,
                color: Colors.blueGrey.shade900.withOpacity(0.8),
              ),
            ),
          ),

          Positioned(
              // duration: Duration(milliseconds: 500),
              // top: ispasswordtapped
              //     ? 100
              //     : isconfirmpassTapped
              //         ? 0
              //         : isValidated
              //             ? 130
              //             : 100,

              //Previous Used top position
              // top: ispasswordtapped
              //     ? 145
              //     : isconfirmpassTapped
              //         ? 120
              //         : 145,

              top: SizeConfig.safeBlockVertical * 21.3,
              // top: 135,
              child: Container(
                // color: Colors.white,
                // height: 300,
                height: SizeConfig.safeBlockVertical * 52,
                width: MediaQuery.of(context).size.width - 50,
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          shrinkWrap: true,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 25, left: 15, right: 15),
                                child: Textfields(
                                    validate: nameValidator,
                                    controller: controllerFirstName,
                                    hintText: "First Name",
                                    icon: Icons.person_outline)),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 15, right: 15),
                                child: Textfields(
                                    validate: nameValidator,
                                    controller: controllerLastName,
                                    hintText: "Last Name",
                                    icon: Icons.person_outline)),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 15, right: 15),
                                child: Textfields(
                                    validate: emailValidator,
                                    controller: controllerEmail,
                                    hintText: "Enter Email",
                                    icon: Icons.mail_outline)),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: 10.0, left: 15.0, right: 15.0),
                                child: Textfields(
                                  focusNode: focusNode,
                                  validate: passwordValidator,
                                  controller: controllerPassword,
                                  hintText: "Password",
                                  icon: Icons.lock_outlined,
                                  secure: _isObscure,
                                  suffixIcon: IconButton(
                                      color: Colors.white,
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
                                )),

                            //Confirm Passwrod Field
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Focus(
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  // controller: _password,
                                  cursorColor: Colors.white,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter password to Confirm";
                                    } else if (value !=
                                        controllerPassword.text) {
                                      return "Password does not match";
                                    }
                                  },
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white.withOpacity(0.2),
                                    filled: true,
                                    prefixIcon: Icon(Icons.lock_outlined,
                                        color: Colors.white),
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white.withOpacity(0.5)),
                                    errorStyle: TextStyle(color: Colors.yellow),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.0)),
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.yellow)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide:
                                            BorderSide(color: Colors.yellow)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      //Full Name Field
                    ],
                  ),
                ),
              )),

          //SIGNUP BUtton
          AnimatedPositioned(
            duration: Duration(milliseconds: 100),
            // curve: Curves.bounceInOut,
            // top: ispasswordtapped
            //     ? 390
            //     : isconfirmpassTapped
            //         ? 400
            //         : isValidated
            //             ? 555
            //             : 625,
            // top: 535,
            top: SizeConfig.safeBlockVertical * 78.7,
            left: 110,
            right: 110,
            child: GestureDetector(
              child: Container(
                // height: 40.0,
                height: SizeConfig.safeBlockVertical * 5.8,
                // width: 150,
                width: SizeConfig.safeBlockHorizontal * 36.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(colors: <Color>[
                      Color(0xff7f29a5).withOpacity(0.8),
                      Color(0xff6742be).withOpacity(0.8)
                    ])
                    // Decorate here
                    ),
                child: Center(
                  child: Visibility(
                      visible: visible,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            letterSpacing: 2,
                            // fontSize: 19,
                            fontSize: SizeConfig.safeBlockVertical * 3.2,
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
                            " Sign Up",
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
                  firstName = controllerFirstName.text;
                  lastName = controllerLastName.text;
                  void remove() {
                    setState(() {
                      visible = !visible;
                    });
                  }

                  var signupdetails = {
                    'first_name': firstName,
                    'last_name': lastName,
                    'email': email,
                    'password': password
                  };

                  Auth auth =
                      Auth(context: context, signupdetails: signupdetails);
                  auth.signUpAPI().whenComplete(() => remove());
                } else {
                  setState(() {
                    isValidated = false;
                  });
                }
              },
            ),
          ),
          Positioned(
            // top: 620,
            top: SizeConfig.safeBlockVertical * 91,
            left: 10.0,
            right: 20.0,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: "Already have an account?",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.blueGrey[50],
                  ),
                ),
                WidgetSpan(
                    child: GestureDetector(
                  child: Text(
                    " Log In",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      // fontSize: 14,
                      fontSize: SizeConfig.safeBlockVertical * 2.1,
                      color: Colors.grey[100],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
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
