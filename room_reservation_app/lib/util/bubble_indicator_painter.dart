import 'package:flutter/material.dart';

class BubbleIndicatorPainter extends CustomPainter {
  final PageController pageController;
  final Paint painter;

  BubbleIndicatorPainter({required this.pageController})
      : painter = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Your custom painting code
  }

  @override
  bool shouldRepaint(BubbleIndicatorPainter oldDelegate) {
    return true;
  }
}
