import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffB8D2F5)
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const gap = 4.0;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );

      startX += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}