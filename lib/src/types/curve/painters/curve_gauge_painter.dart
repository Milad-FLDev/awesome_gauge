import 'dart:math';
import 'package:flutter/material.dart';

class CurveGaugePainter extends CustomPainter {

  /// Angle of selected point
  final double pointAngle;

  /// Maximum value on the scale
  final int max;

  /// Text style for costume label style
  final TextStyle? labelStyle;

  /// Set color on middle ticks and labels
  final Color? color;

  CurveGaugePainter({
    required this.pointAngle,
    required this.max,
    this.labelStyle,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 1.52;
    final Offset center = Offset(radius, radius);


    /// Draw the circular scale with labels
    for (int i = 0; i < max; i++) {
      final double tickAngle = (i / max) * 2 * pi + (pointAngle + 4.7);
      final double outerRadius = radius;
      final double innerRadius = (i % 20 == 0) ?
      radius - 25 : (i % 10 == 0) ? radius - 25 : radius - 15;

      final Paint paint = Paint()
        ..color = (i % 20 == 0) ? Colors.grey : (i % 10 == 0) ?
        color ?? Colors.deepOrange : Colors.grey.withOpacity(0.6)

        ..strokeWidth = 1;


      final Offset start = Offset(
        center.dx + outerRadius * cos(tickAngle),
        center.dy + outerRadius * sin(tickAngle),
      );

      final Offset end = Offset(
        center.dx + innerRadius * cos(tickAngle),
        center.dy + innerRadius * sin(tickAngle),
      );

      canvas.drawLine(start, end, paint);

      /// Draw value labels under major ticks
      if (i % 20 == 0) {
        /// Calculate the value for the label based on the tick index
        final double weight = ((i / max) * max);
        _drawLabel(canvas, center, tickAngle, weight, radius,size.width);
      }
    }
  }

  void _drawLabel(Canvas canvas, Offset center, double tickAngle,
      double weight, double radius , double size) {
    final TextSpan span = TextSpan(
        text: weight.toStringAsFixed(0), // Display integer weight values
        style: labelStyle ?? TextStyle(
            color: color ?? Colors.deepOrange,
            fontWeight: FontWeight.w400,
            fontSize: size/30
        )
    );

    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    /// Calculate the label position slightly below the major tick mark
    final double labelRadius = radius - (size/9); /// Position below the major tick
    final Offset labelOffset = Offset(
      center.dx + labelRadius * cos(tickAngle) - textPainter.width / 2,
      center.dy + labelRadius * sin(tickAngle) - textPainter.height / 2,
    );

    textPainter.paint(canvas, labelOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}