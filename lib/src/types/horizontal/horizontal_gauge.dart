import 'dart:async';
import 'package:awesome_gauges/src/extension/double_round.dart';
import 'package:flutter/material.dart';

class HorizontalGauge extends StatefulWidget {

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

  const HorizontalGauge({
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
  State<HorizontalGauge> createState() => _HorizontalGaugeState();
}

class _HorizontalGaugeState extends State<HorizontalGauge> {

  late ScrollController scrollController;
  double buttonPosition = 60;
  double selectedValue = 0.0;
  late StreamController<String> _holdStreamController;
  bool _isHolding = false;
  late DateTime _holdTime;
  double scaleItem = 7.9;


  @override
  void initState() {
    selectedValue = widget.initialValue;
    scrollController = ScrollController(initialScrollOffset: widget.initialValue*7.9);
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
                  fontSize: widget.width/8
              ),
            ),
            Text(
              '${widget.measurementScale} ',
              style: TextStyle(
                  color: widget.gaugeColor ?? Colors.deepOrange,
                  fontSize: widget.width/8
              ),
            ),
          ],
        ),
        SizedBox(height: 8,),
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
                padding: EdgeInsets.symmetric(vertical: 26),
                child: ListView.builder(
                  itemCount: widget.max+1,
                  controller: scrollController,
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: (widget.width/2)-12
                  ),
                  itemBuilder: (context, index) {
                    bool isSpecialWidth = (index + 1) % 10 == 1;
                    bool isMiddleWidth = (index + 1) % 5 == 1;
                    //scaleHeight = isSpecialWidth ? 11.h : isMiddleWidth ? 5.h : 5.h;
                    return SizedBox(
                      width: isSpecialWidth ? 16 : 7,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: isSpecialWidth ? 36 : isMiddleWidth ? 25 : 15,
                            width: isSpecialWidth ? 2 : isMiddleWidth ? 1.5 : 1,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: isSpecialWidth
                                  ? Colors.grey
                                  : isMiddleWidth
                                  ? widget.gaugeColor ?? Colors.deepOrange
                                  : Colors.grey,
                            ),
                          ),

                          Positioned(
                            bottom: 40,
                            child: Text(
                              (index + 1) % 10 == 1 ? '$index' : '',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
            SizedBox(
              width: 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 1,
                    height: 125,
                    color: widget.gaugeColor ?? Colors.deepOrange,
                  ),
                  Positioned(
                    bottom: 0,
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
                    top: 15,
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
            )
          ],
        ),
        SizedBox(height: 16,),
        /// drag to select a value
        SizedBox(
          width: 150,
          height: 31,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 5,
                color: Colors.grey.withOpacity(0.3),
              ),
              AnimatedPositioned(
                  left: buttonPosition,
                  duration: Duration(milliseconds: 300),
                  child: GestureDetector(
                    onHorizontalDragUpdate: (detail){

                      bool isMoveToRight = detail.delta.direction <= 0.0 ? true : false;

                      if(!isMoveToRight){
                        buttonPosition = (-detail.globalPosition.dy*0.008);
                      }else{
                        buttonPosition = (detail.globalPosition.dy*0.19);
                      }
                    },
                    onHorizontalDragEnd: (detail){
                      /// Back to initial button position
                      _stopHolding();
                      buttonPosition = 60;
                      setState(() {});
                    },
                    onHorizontalDragStart: (_) {
                      /// Start the holding stream when the user presses
                      _startHolding();
                    },
                    onHorizontalDragCancel: () {
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
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  left: 0,
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                  )
                              ),
                              Positioned(
                                right: 0,
                                child: Icon(
                                  Icons.keyboard_arrow_left,
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
    );
  }
}
