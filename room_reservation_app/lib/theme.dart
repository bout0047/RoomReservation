import 'package:flutter/cupertino.dart';

class CustomTheme {
  static const Color loginGradientStart = Color(0xFF2196F3); // Blue start
  static const Color loginGradientEnd = Color(0xFF1976D2);   // Blue end
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
