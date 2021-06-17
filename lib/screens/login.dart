// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_home_app/config/palette.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smart_home_app/screens/newSignUp.dart';
import 'package:smart_home_app/screens/signup.dart';
import 'package:smart_home_app/config/sizeconfig.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  String? email, password;
  bool _isObscure = true;

  var _password = TextEditingController();
  bool isValidated = true;

  //Validators
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "This field is Required*"),
    EmailValidator(errorText: "Please Enter a Valid Email")
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is Required*'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

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
                                      child: TextFormField(
                                        cursorColor: Colors.black,
                                        validator: emailValidator,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Colors.grey,
                                          ),
                                          // labelText: "First Name",
                                          hintText: "Enter Email",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                                color: Palette.activeColor),
                                          ),

                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              borderSide: BorderSide(
                                                  color: Colors.red)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                        ),
                                        onChanged: (String useremail) {
                                          setState(() {
                                            email = useremail;
                                          });
                                        },
                                      )),
                                  //Password Field
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: TextFormField(
                                      controller: _password,
                                      cursorColor: Colors.black,
                                      validator: passwordValidator,
                                      obscureText: _isObscure,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock_outlined,
                                            color: Colors.grey),
                                        suffixIcon: IconButton(
                                            color: _password.text.isEmpty
                                                ? Colors.grey
                                                : Palette.activeColor,
                                            icon: Icon(_isObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            }),
                                        hintText: "Enter Password",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              color: Palette.activeColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                      ),
                                      onChanged: (String userpassword) {
                                        setState(() {
                                          password = userpassword;
                                        });
                                      },
                                    ),
                                  ),
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
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              letterSpacing: 2,
                                              fontSize: 18,
                                              fontFamily: "Poppins",
                                              color: Color(0xffc8bce3)),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      if (_formkey.currentState!.validate()) {
                                        isValidated = true;
                                        final snackBar = SnackBar(
                                            content: Text('Processing!!'));

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        setState(() {
                                          isValidated = false;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                              //EMAIL Field
                            ],
                          ),
                        ),
                      ],
                    )),
              )),
          // AnimatedPositioned(
          //   duration: Duration(milliseconds: 350),
          //   // curve: Curves.bounceInOut,
          //   // top: isValidated ? 430 : 470,
          //   top: isValidated
          //       ? SizeConfig.blockSizeVertical * 52
          //       : SizeConfig.blockSizeVertical * 67,
          //   left: 130,
          //   right: 130,
          //   child: GestureDetector(
          //     child: Container(
          //       height: 40.0,
          //       width: 120.0,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(20.0),
          //           gradient: LinearGradient(
          //               colors: <Color>[Color(0xff7f29a5), Color(0xff6742be)])
          //           // Decorate here
          //           ),
          //       child: Center(
          //         child: Text(
          //           "Login",
          //           style: TextStyle(
          //               letterSpacing: 2,
          //               fontSize: 18,
          //               fontFamily: "Poppins",
          //               color: Color(0xffc8bce3)),
          //         ),
          //       ),
          //     ),
          //     onTap: () {
          //       if (_formkey.currentState!.validate()) {
          //         isValidated = true;
          //         final snackBar = SnackBar(content: Text('Processing!!'));

          //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //       } else {
          //         setState(() {
          //           isValidated = false;
          //         });
          //       }
          //     },
          //   ),
          // ),
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
                    Navigator.push(
                        context,
                        PageTransition(
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

  // Route _createRoute() {
  //   return PageRouteBuilder(
  //       pageBuilder: (context, animation, secondaryAnimation) => SignupScreen(),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         var begin = Offset(0.0, 1.0);
  //         var end = Offset.zero;
  //         var curve = Curves.ease;

  //         var tween =
  //             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //         return FadeTransition(
  //           // position: animation.drive(tween),
  //           opacity: animation,
  //           child: child,
  //         );
  //       },
  //       transitionDuration: Duration(milliseconds: 500));
  // }
}
