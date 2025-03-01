import 'package:awesome_gauges/awesome_gauges.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// Awesome gauge widget
              // AwesomeGauge.curveGauge(
              //   gaugeType: GaugeType.curve,
              //   size: 450,
              //   initialValue: 80,
              //   max: 300,
              //   measurementScale: 'kg',
              //   gaugeColor: Colors.deepOrange,
              //   backgroundColor: Colors.white,
              //   onChangeValue: (value) {
              //     /// Use returned value in your code
              //   },
              // ),

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
            ],
          ),
        ),
      ),
    );
  }
}