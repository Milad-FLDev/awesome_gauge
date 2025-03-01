import 'dart:async';
import 'package:awesome_gauges/src/extension/double_round.dart';
import 'package:flutter/material.dart';

class VerticalGauge extends StatefulWidget {

  /// This function return selected value
  final Function(double) onChangeValue;

  /// Show value on init vertical gauge
  final double initialValue;

  /// Size of width gauge
  final double width;

  /// Size of height gauge
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

  const VerticalGauge({
    super.key,
    required this.onChangeValue,
    required this.initialValue,
    required this.width,
    required this.height,
    required this.max,
    required this.measurementScale,
    this.gaugeColor,
    this.backgroundColor,
    this.labelStyle,
  });

  @override
  State<VerticalGauge> createState() => _VerticalGaugeState();
}

class _VerticalGaugeState extends State<VerticalGauge> {

  late ScrollController scrollController;
  double buttonPosition = 60;
  double selectedValue = 0.0;
  late StreamController<String> _holdStreamController;
  bool _isHolding = false;
  late DateTime _holdTime;
  double scaleItem = 7.5;


  @override
  void initState() {
    selectedValue = widget.initialValue;
    scrollController = ScrollController(initialScrollOffset: widget.initialValue*7.5);
    _holdStreamController = StreamController<String>();
    scrollController.addListener((){
      if(_isHolding == false){
        final currentPosition = (scrollController.offset/scaleItem).roundTo(0);
        selectedValue = (currentPosition > widget.max ? widget.max.toDouble() : currentPosition).roundTo(0);
        widget.onChangeValue(selectedValue);
        setState(() {});
      }
    });
    super.initState();
  }


  /// Start stream with drag button
  void _startHolding() {
    _holdStreamController = StreamController<String>();
    _isHolding = true;
    _holdTime = DateTime.now();

    /// Emit events while holding
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_isHolding) {
        changeValueOnStream();
        _holdStreamController.add('${DateTime.now().difference(_holdTime).inMilliseconds}');
      } else {
        timer.cancel(); // Stop emitting events when the hold ends
      }
    });
  }


  /// Change position with start stream
  void changeListPositionOnStream(ConnectionState connectionState){
    if(connectionState == ConnectionState.active){
      if(buttonPosition < 60){
        scrollController.jumpTo(
          scrollController.offset+5,
        );
      }else{
        scrollController.jumpTo(
          scrollController.offset-5,
        );
      }
    }
  }


  /// Change value on stream
  void changeValueOnStream(){
    final currentPosition = (scrollController.offset/scaleItem).roundTo(0);
    if(currentPosition >=0 && currentPosition < (widget.max+1)){
      selectedValue = (currentPosition > widget.max ? widget.max.toDouble() : currentPosition).roundTo(0);
      widget.onChangeValue(selectedValue);
      setState(() {});
    }
  }


  /// Stop stream with drop the button
  void _stopHolding() {
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
    return Column(
      children: [
        /// Show measurement scale
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${selectedValue.toInt()}',
              style: TextStyle(
                  color: widget.gaugeColor ?? Colors.deepOrange,
                  fontSize: widget.width/3
              ),
            ),
            Text(
              '${widget.measurementScale} ',
              style: TextStyle(
                color: widget.gaugeColor ?? Colors.deepOrange,
                fontSize: widget.width/3
              ),
            ),
          ],
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 50,),
            /// gauge box
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: widget.gaugeColor ?? Colors.deepOrange,
                            width: 5
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: ListView.builder(
                      itemCount: widget.max+1,
                      controller: scrollController,
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          vertical: (widget.height/2)-12
                      ),
                      itemBuilder: (context, index) {
                        bool isSpecialWidth = (index + 1) % 10 == 1;
                        bool isMiddleWidth = (index + 1) % 5 == 1;
                        //scaleHeight = isSpecialWidth ? 11.h : isMiddleWidth ? 5.h : 5.h;
                        return SizedBox(
                          height: isSpecialWidth ? 12 : 7,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: isSpecialWidth ? 36 : isMiddleWidth ? 25 : 15,
                                height: isSpecialWidth ? 2 : isMiddleWidth ? 1.5 : 1,
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSpecialWidth
                                      ? Colors.grey
                                      : isMiddleWidth
                                      ? widget.gaugeColor ?? Colors.deepOrange
                                      : Colors.grey,
                                ),
                              ),

                              Positioned(
                                left: 40,
                                bottom: 0,
                                child: Text(
                                  (index + 1) % 10 == 1 ? '$index' : '',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
                Positioned(
                  right: 5,
                  child: SizedBox(
                    height: 9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 125,
                          height: 1,
                          color: widget.gaugeColor ?? Colors.deepOrange,
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                                color: widget.gaugeColor ?? Colors.deepOrange,
                                shape: BoxShape.circle
                            ),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                                color: widget.gaugeColor ?? Colors.deepOrange,
                                shape: BoxShape.circle
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 22,),
            /// drag to select a value
            SizedBox(
              width: 31,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 5,
                    height: 150,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  AnimatedPositioned(
                      top: buttonPosition,
                      duration: Duration(milliseconds: 300),
                      child: GestureDetector(
                        onVerticalDragUpdate: (detail){

                          bool isMoveToTop = detail.delta.direction < 0 ? true : false;

                          if(isMoveToTop){
                            buttonPosition = (-detail.globalPosition.dy*0.008);
                          }else{
                            buttonPosition = (detail.globalPosition.dy*0.19);
                          }
                        },
                        onVerticalDragEnd: (detail){
                          /// Back to initial button position
                          _stopHolding();
                          buttonPosition = 60;
                          setState(() {});
                        },
                        onVerticalDragStart: (_) {
                          /// Start the holding stream when the user presses
                          _startHolding();
                        },
                        onVerticalDragCancel: () {
                          /// Stop the stream if the gesture is canceled
                          _stopHolding();
                        },
                        child: StreamBuilder<String>(
                          stream: _holdStreamController.stream,
                          builder: (context, snapshot) {
                            changeListPositionOnStream(snapshot.connectionState);

                            return Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.gaugeColor ?? Colors.deepOrange
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                      bottom: 0,
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.white,
                                      )
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                  ),
                ],
              ),
            ),


          ],
        ),
      ],
    );
  }
}
