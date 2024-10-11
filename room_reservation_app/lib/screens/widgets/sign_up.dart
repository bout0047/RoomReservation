import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:room_reservation_app/theme.dart';
import 'package:room_reservation_app/screens/widgets/snackbar.dart'; // Correct import path

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 360.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: TextField(
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.envelope, size: 22.0, color: Colors.black),
                            hintText: 'Email Address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(height: 1.0, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: TextField(
                          controller: signupPasswordController,
                          obscureText: _obscureTextPassword,
                          style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.lock, size: 22.0, color: Colors.black),
                            hintText: 'Password',
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureTextPassword = !_obscureTextPassword;
                                });
                              },
                              child: Icon(
                                _obscureTextPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(height: 1.0, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: TextField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextConfirmPassword,
                          style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.lock, size: 22.0, color: Colors.black),
                            hintText: 'Confirm Password',
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                                });
                              },
                              child: Icon(
                                _obscureTextConfirmPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 340.0),
                decoration: BoxDecoration(
                  gradient: CustomTheme.primaryGradient,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [BoxShadow(color: CustomTheme.loginGradientStart, blurRadius: 20.0)],
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text('SIGN UP', style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'WorkSansBold')),
                  ),
                  onPressed: () => CustomSnackBar.show(context, 'Sign Up button pressed'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
