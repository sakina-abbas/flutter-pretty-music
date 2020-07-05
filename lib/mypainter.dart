import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'constants.dart';

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({Key key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter / 2),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = kHotPinkColor;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height, size.width / 2),
        height: size.height * 2,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}