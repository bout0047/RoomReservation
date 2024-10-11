import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_reservation_app/providers/auth_provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _isLoading = false;

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
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: TextField(
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(Icons.email, size: 22.0, color: Colors.black),
                            hintText: 'Email Address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(height: 1.0, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                        child: TextField(
                          controller: loginPasswordController,
                          obscureText: _obscureTextPassword,
                          style: TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock, size: 22.0, color: Colors.black),
                            hintText: 'Password',
                            border: InputBorder.none,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureTextPassword = !_obscureTextPassword;
                                });
                              },
                              child: Icon(
                                _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
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
                margin: const EdgeInsets.only(top: 170.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.red],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [BoxShadow(color: Colors.orange, blurRadius: 20.0)],
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.red,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'WorkSansBold'),
                          ),
                        ),
                  onPressed: () => _login(context),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text('Forgot Password?', style: TextStyle(color: Colors.white, fontSize: 16.0)),
          ),
        ],
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final email = loginEmailController.text;
    final password = loginPasswordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await Provider.of<AuthProvider>(context, listen: false).login(email, password);
        // Navigate to the home page or show success message
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
