import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_reservation_app/providers/auth_provider.dart';
import 'package:room_reservation_app/screens/widgets/sign_in.dart' as SignInWidget;
import 'package:room_reservation_app/screens/widgets/sign_up.dart' as SignUpWidget;
import 'package:room_reservation_app/util/bubble_indicator_painter.dart';
import 'package:room_reservation_app/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[CustomTheme.loginGradientStart, CustomTheme.loginGradientEnd],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                stops: <double>[0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 75.0),
                  child: Image(
                    height: MediaQuery.of(context).size.height > 800 ? 191.0 : 150,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/img/login_logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    physics: ClampingScrollPhysics(),
                    onPageChanged: (int i) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        if (i == 0) {
                          right = Colors.white;
                          left = Colors.black;
                        } else {
                          right = Colors.black;
                          left = Colors.white;
                        }
                      });
                    },
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: SignInWidget.SignIn(), // Alias used here
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: SignUpWidget.SignUp(), // Alias used here
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: _onSignInButtonPress,
                child: Text(
                  'Existing',
                  style: TextStyle(color: left, fontSize: 16.0, fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'New',
                  style: TextStyle(color: right, fontSize: 16.0, fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
