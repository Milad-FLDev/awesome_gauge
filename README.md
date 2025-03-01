awesome_gauge is a package for build gauge.


## Features

<table>
  <tr>
    <td><img src="https://github.com/Milad-FLDev/awesome_gauges/raw/Milad/video/gif_curve.gif" alt="Curve gauge" width="200"></td>
    <td><img src="https://github.com/Milad-FLDev/awesome_gauges/raw/Milad/video/gif_horizontal.gif" alt="Horizontal gauge" width="200"></td>
    <td><img src="https://github.com/Milad-FLDev/awesome_gauges/raw/Milad/video/gif_vertical.gif" alt="Vertical gauge" width="200"></td>
  </tr>
</table>


## Curve example

```dart
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
 )
```


## Vertical example

```dart
AwesomeGauge.verticalGauge(
  gaugeType: GaugeType.vertical,
  height: 600,
  initialValue: 90,
  max: 300,
  measurementScale: 'kg',
  gaugeColor: Colors.deepOrange,
  backgroundColor: Colors.white,
  onChangeValue: (value) {
  /// Use returned value in your code
  },
),
```


## Horizontal example

```dart
AwesomeGauge.horizontalGauge(
  gaugeType: GaugeType.horizontal,
  width: 400,
  initialValue: 10,
  max: 400,
  measurementScale: 'kg',
  gaugeColor: Colors.deepOrange,
  backgroundColor: Colors.white,
  onChangeValue: (value) {
  /// Use returned value in your code
  },
)
```
