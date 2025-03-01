awesome_gauge is a package for build gauge.


## Features

Curve gauge 

![gif_curve.gif](video/gif_curve.gif)

Horizontal gauge

![gif_horizontal.gif](video/gif_horizontal.gif)

Vertical gauge

![gif_vertical.gif](video/gif_vertical.gif)


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