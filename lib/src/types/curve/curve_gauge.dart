import 'dart:async';
import 'package:awesome_gauges/src/extension/double_round.dart';
import 'package:awesome_gauges/src/types/curve/painters/curve_gauge_painter.dart';
import 'package:awesome_gauges/src/types/curve/widgets/arc_drag_button.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CurveGauge extends StatefulWidget {

  /// This function return selected value
  final Function(double) onChangeValue;

  /// Show value on init Curve gauge
  final double initialValue;

  /// Curve gauge [size]
  final double size;

  /// Maximum value on the scale
  final int max;

  /// Color for label,border
  final Color? gaugeColor;

  /// Color for gauge background
  final Color? backgroundColor;

  /// Measurement Scale for value
  final String measurementScale;

  /// Text style for label
  final TextStyle? labelStyle;

  const CurveGauge({
    super.key,
    required this.onChangeValue,
    required this.initialValue,
    required this.size,
    required this.max,
    required this.measurementScale,
    this.gaugeColor,
    this.backgroundColor,
    this.labelStyle,
  });

  @override
  State<CurveGauge> createState() => _CurveGaugeState();
}

class _CurveGaugeState extends State<CurveGauge> {

  /// Point angle
  double _angle = 0;

  /// selected value
  double value = 0;


  late StreamController<String> _holdStreamController;
  bool _isHolding = false;
  late DateTime _holdStartTime;

  @override
  void initState() {
    value = widget.initialValue;
    _angle = 6.2813 - _valueToAngle(value);
    _holdStreamController = StreamController<String>();
    super.initState();
  }


  /// Function to convert weight to angle
  double _valueToAngle(double weight) {
    return (weight  / widget.max) * 2 * pi;
  }

  void _onPanUpdate({
    DragUpdateDetails? dragUpdate,
    DragStartDetails? dragStart,
    required bool withController
  }) {
      /// Calculate the new angle based on touch movement
      if(withController){
        if(dragUpdate != null){
          _angle += dragUpdate.delta.dx * 0.002;
        }else{
          _angle += dragStart!.globalPosition.dx * 0.002;
        }
      }else{
        if(dragUpdate != null){
          _angle += dragUpdate.delta.dx * 0.002;
        }else{
          _angle += dragStart!.globalPosition.dx * 0.002;
        }
      }


      /// Keep the angle within the 0 to 2*pi range
      _angle = _angle % (2 * pi);

      /// Convert angle to weight (based on minWeight and maxWeight)
      double selectedWeight = ((_angle / (2 * pi) * widget.max)
            .clamp(0, widget.max))
            .toDouble().roundTo(0);

      value = (selectedWeight - widget.max).abs();

      setState(() {});

      widget.onChangeValue(value);
  }

  void _startStream(DragUpdateDetails detail) {
    _holdStreamController = StreamController<String>();
    _isHolding = true;
    _holdStartTime = DateTime.now();

    /// Emit events while holding
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (_isHolding) {
        _onPanUpdate(dragUpdate: detail,withController: true);
        _holdStreamController.add('Holding for: ${DateTime.now().difference(_holdStartTime).inMinutes}ms');
      } else {
        /// Stop emitting events when the hold ends
        timer.cancel();
      }
    });
  }

  void _stopStream() {
    _holdStreamController.close();
    _isHolding = false;
  }

  @override
  void dispose() {
    _holdStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size > 700 ? 700 : widget.size,
      width: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Top border of gauge
          Positioned(
            bottom: -widget.size*1.15,
            right: -widget.size/5,
            left: -widget.size/5,
            child: Container(
              width: widget.size*1.2,
              height: widget.size*2,
              decoration: BoxDecoration(
                  color: widget.gaugeColor ?? Colors.deepOrange, shape: BoxShape.circle),
            ),
          ),

          /// Top border of gauge
          Positioned(
            bottom: -widget.size*1.17,
            right: -widget.size/5,
            left: -widget.size/5,
            child: Container(
              width: widget.size*1.2,
              height: widget.size*2,
              decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white, shape: BoxShape.circle),
            ),
          ),

          /// Bottom border of gauge
          Positioned(
            bottom: -widget.size/1.3,
            right: -widget.size/20,
            left: -widget.size/20,
            child: Container(
              width: widget.size*2,
              height: widget.size*1.1,
              decoration: BoxDecoration(
                  color: widget.gaugeColor ?? Colors.deepOrange, shape: BoxShape.circle),
            ),
          ),

          /// Show Curve Gauge Painter
          Positioned(
            bottom: -widget.size/1.02,
            right: widget.size/6.7,
            left: -widget.size/5.5,
            child: GestureDetector(
              onPanUpdate: (detail){
                _onPanUpdate(dragUpdate: detail, withController: false);
              },
              child: CustomPaint(
                size: Size(widget.size/20,widget.size*1.48), // Define the size of the circular ruler
                painter: CurveGaugePainter(
                  pointAngle: _angle,
                  color: widget.gaugeColor ?? Colors.deepOrange,
                  max: widget.max,
                  labelStyle: widget.labelStyle
                ),
              ),
            ),
          ),

          Positioned(
            bottom: widget.size/3,
            right: widget.size/2,
            child: SizedBox(
              width: 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 1,
                    height: widget.size/5.5,
                    color: widget.gaugeColor ?? Colors.deepOrange,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: widget.gaugeColor ?? Colors.deepOrange,
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          color: widget.gaugeColor ?? Colors.deepOrange,
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Show arc drag button
          Positioned(
            bottom: -widget.size/1.35,
            right: -widget.size/5,
            left: -widget.size/5,
            child: Container(
                width: widget.size*2,
                height: widget.size*1.055,
                decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.white,
                    shape: BoxShape.circle),
                child: Column(
                  children: [
                    SizedBox(height: widget.size/20,),
                    ArcDragButton(
                      onPanUpdate: (detail){
                        _startStream(detail);
                      },
                      onPanEnd: (detail){
                        _stopStream();
                      },
                      iconSize: 30,
                      iconColor: widget.gaugeColor ?? Colors.deepOrange,
                    )
                  ],
                )
            ),
          ),

          /// Show selected value
          Positioned(
            bottom: widget.size/1.7,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(
                      color: widget.gaugeColor ?? Colors.deepOrange,
                      fontSize: widget.size/14,
                      fontWeight: FontWeight.w400
                  ),
                ),
                Text(
                  ' ${widget.measurementScale} ',
                  style: TextStyle(
                      color: widget.gaugeColor ?? Colors.deepOrange,
                      fontSize: widget.size/14,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
