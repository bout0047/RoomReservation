import 'package:flutter/material.dart';
import 'dart:math';

class BubblesBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: BubblePainter(),
    );
  }
}

class BubblePainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final radius = _random.nextDouble() * 60 + 30;
      final offset = Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      );
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
