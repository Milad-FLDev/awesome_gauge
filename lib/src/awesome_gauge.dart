import 'package:awesome_gauges/src/types/curve/curve_gauge.dart';
import 'package:awesome_gauges/src/types/horizontal/horizontal_gauge.dart';
import 'package:awesome_gauges/src/types/vertical/vertical_gauge.dart';
import 'package:awesome_gauges/src/values/states.dart';
import 'package:flutter/material.dart';

class AwesomeGauge extends StatelessWidget {

  /// Choose type of gauge
  final GaugeType gaugeType;

  /// This function return selected value
  final Function(double) onChangeValue;

  /// Show value on init Curve gauge
  final double initialValue;

  /// size of Curve gauge
  final double size;

  /// size of width gauge
  final double width;

  /// size of height gauge
  final double height;

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


  // const AwesomeGauge({
  //   super.key,
  //   required this.gaugeType,
  //   required this.size,
  //   required this.initialValue,
  //   required this.max,
  //   required this.onChangeValue,
  //   required this.measurementScale,
  //   this.gaugeColor,
  //   this.backgroundColor,
  //   this.labelStyle,
  // });



  const AwesomeGauge.curveGauge({
    super.key,
    required this.gaugeType,
    required this.onChangeValue,
    required this.initialValue,
    required this.size,
    required this.max, this.gaugeColor,
    this.backgroundColor,
    required this.measurementScale,
    this.labelStyle,
  }) : width = 0,height = 0;


  const AwesomeGauge.verticalGauge({
    super.key,
    required this.gaugeType,
    required this.onChangeValue,
    required this.initialValue,
    required this.max, this.gaugeColor,
    this.backgroundColor,
    required this.measurementScale,
    this.labelStyle,
    required this.height,
  }) : size = 0,width = 140;



  const AwesomeGauge.horizontalGauge({
    super.key,
    required this.gaugeType,
    required this.onChangeValue,
    required this.initialValue,
    required this.max, this.gaugeColor,
    this.backgroundColor,
    required this.measurementScale,
    this.labelStyle,
    required this.width,
  }) : size = 0,height = 140;



  @override
  Widget build(BuildContext context) {
    switch (gaugeType) {
      case GaugeType.vertical:
        return VerticalGauge(
          onChangeValue: onChangeValue,
          initialValue: initialValue,
          width: width,
          height: height,
          max: max,
          measurementScale: measurementScale,
          gaugeColor: gaugeColor,
          backgroundColor: backgroundColor,
          labelStyle: labelStyle,
        );

      case GaugeType.horizontal: return HorizontalGauge(
        onChangeValue: onChangeValue,
        initialValue: initialValue,
        width: width,
        height: height,
        max: max,
        measurementScale: measurementScale,
        gaugeColor: gaugeColor,
        backgroundColor: backgroundColor,
        labelStyle: labelStyle,
      );

      case GaugeType.curve:
        final gaugeSize = size > MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width : size;
        return CurveGauge(
          onChangeValue: onChangeValue,
          initialValue: initialValue,
          size: gaugeSize,
          max: max,
          measurementScale: measurementScale,
          gaugeColor: gaugeColor,
          backgroundColor: backgroundColor,
          labelStyle: labelStyle,
        );
    }
  }
}
