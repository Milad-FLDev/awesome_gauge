awesome_gauge is a package for build gauge.


## Features

curve gauge
![gif_curve.gif](video/gif_curve.gif)

horizontal gauge
![gif_horizontal.gif](video/gif_horizontal.gif)

vertical gauge
![gif_vertical.gif](video/gif_vertical.gif)

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

Column(
 mainAxisAlignment: MainAxisAlignment.end,
 children: [
  /// Awesome gauge widget
  AwesomeGauge.curveGauge(
  gaugeType: GaugeType.curve,
  size: 450,
  initialValue: 80,
  max: 300,
  measurementScale: 'kg',
  gaugeColor: Colors.deepOrange,
  backgroundColor: Colors.white,
  onChangeValue: (value) {
  /// Use returned value in your code
  },
),