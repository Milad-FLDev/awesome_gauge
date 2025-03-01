import 'dart:math';
import 'package:awesome_gauges/src/types/curve/painters/arc_painter.dart';
import 'package:flutter/material.dart';

class ArcDragButton extends StatefulWidget {

  /// Return update detail on drag
  final Function(DragUpdateDetails) onPanUpdate;

  /// return detail on end of drag
  final Function(DragEndDetails) onPanEnd;

  /// Size of button on the arc
  final double iconSize;

  /// Color of button on the arc
  final Color iconColor;


  const ArcDragButton({
    super.key,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.iconSize,
    required this.iconColor,
  });

  @override
  State<ArcDragButton> createState() => _ArcDragButtonState();
}

class _ArcDragButtonState extends State<ArcDragButton> with SingleTickerProviderStateMixin {

  /// Angle of button on the arc
  double _angle = 0.0;

  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _angle = _animation.value;
        });
      });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _angle = (_angle + details.delta.dx / 100).clamp(-pi / 4, pi / 4);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _animation = Tween<double>(begin: _angle, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Arc Background
        CustomPaint(
          painter: ArcPainter(),
          child: Transform.rotate(
            angle: 3.14,
            child: Transform.translate(
              offset: Offset(135 * sin(_angle),90 * cos(_angle) - 90),
              child: GestureDetector(
                onPanUpdate: (detail){
                  _onPanUpdate(detail);
                  widget.onPanUpdate(detail);
                },
                onPanEnd:(detail){
                  _onPanEnd(detail);
                  widget.onPanEnd(detail);
                },
                child: Container(
                  width: widget.iconSize,
                  height: widget.iconSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.iconColor
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.only(left: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          right: 0,
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: widget.iconSize*0.8,
                          )
                      ),
                      Positioned(
                        left: 0,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                          size: widget.iconSize*0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
