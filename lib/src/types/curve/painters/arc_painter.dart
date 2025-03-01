import 'dart:math';
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0;

    final path = Path();
    path.arcTo(
      Rect.fromCircle(
          center: Offset(size.width / 2.3, 195),
          radius: 182
      ),
      -pi + 1.04,
      pi - 2.1,
      false,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
