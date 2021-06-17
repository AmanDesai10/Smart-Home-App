import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:smart_home_app/config/palette.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  String? email, password, fullName;
  bool _isObscure = true;
  double _animatedheight = 3, _animatedwidth = 55.0;
  var _password = TextEditingController();
  bool isValidated = true;
  bool ispasswordtapped = false, isconfirmpassTapped = false;

  // FocusNode? focuspassword;
  // @override
  // void initState() {
  //   super.initState();
  //   focuspassword = FocusNode();
  // }

  // void dispose() {
  //   focuspassword!.dispose();
  //   super.dispose();
  // }

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
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  @override
  Widget build(BuildContext context) {
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
          AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: ispasswordtapped
                  ? 100
                  : isconfirmpassTapped
                      ? 20
                      : isValidated
                          ? 200
                          : 100,

              // top: 200,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 5)
                    ]),
                height: isValidated
                    ? 420 //MediaQuery.of(context).size.height - 290
                    : 475.0,
                width: MediaQuery.of(context).size.width - 50,
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30.0,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          height: _animatedheight,
                          width: _animatedwidth,
                          color: Colors.indigoAccent[200],
                        ),

                        //Full Name Field
                        Padding(
                            padding:
                                EdgeInsets.only(top: 25, left: 15, right: 15),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              validator: nameValidator,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person_outlined,
                                  color: Colors.grey,
                                ),
                                // labelText: "Full Name",
                                hintText: "Your Full Name",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Palette.activeColor),
                                ),

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(25.0)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              onChanged: (String userfullname) {
                                setState(() {
                                  fullName = userfullname;
                                });
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 15, right: 15),
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
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Palette.activeColor),
                                ),

                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(25.0)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              onChanged: (String useremail) {
                                setState(() {
                                  email = useremail;
                                });
                              },
                            )),

                        //Password Field
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 10.0, left: 15.0, right: 15.0),
                          child: Focus(
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
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    }),
                                hintText: "Enter Password",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Palette.activeColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(25.0)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              onChanged: (String userpassword) {
                                setState(() {
                                  password = userpassword;
                                });
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                setState(() {
                                  ispasswordtapped = true;
                                });
                              } else {
                                ispasswordtapped = false;
                              }
                            },
                          ),
                        ),

                        //Confirm Passwrod Field
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 10.0, left: 15.0, right: 15.0),
                          child: Focus(
                            child: TextFormField(
                              controller: _password,
                              cursorColor: Colors.black,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter password to Confirm";
                                } else if (value != password) {
                                  return "Password does not match";
                                }
                              },
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outlined,
                                    color: Colors.grey),
                                hintText: "Confirm Password",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Palette.activeColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(25.0)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                setState(() {
                                  isconfirmpassTapped = true;
                                });
                              } else {
                                isconfirmpassTapped = false;
                              }
                            },
                          ),
                        ),
                      ],
                    )),
              )),

          //SIGNUP BUtton
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            // curve: Curves.bounceInOut,
            top: ispasswordtapped
                ? 460
                : isconfirmpassTapped
                    ? 380
                    : isValidated
                        ? 555
                        : 525,
            left: 130,
            right: 130,
            child: GestureDetector(
              child: Container(
                height: 40.0,
                width: 120.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                        colors: <Color>[Color(0xff7f29a5), Color(0xff6742be)])
                    // Decorate here
                    ),
                child: Center(
                  child: Text(
                    "SignUp",
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
                  final snackBar = SnackBar(content: Text('Processing!!'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  setState(() {
                    isValidated = false;
                  });
                }
              },
            ),
          ),
          Positioned(
            top: 640,
            left: 10.0,
            right: 20.0,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: "Already have an account?",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Palette.textColor1,
                  ),
                ),
                WidgetSpan(
                    child: GestureDetector(
                  child: Text(
                    " Log In",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      // fontSize: 15.0,
                      color: Color(0xff6742be),
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
