import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

/// Customable and attractive Switch button.
/// Currently, you can't change the widget
/// width and height properties.
///
/// As well as the classical Switch Widget
/// from flutter material, the following
/// arguments are required:
///
/// * [value] determines whether this switch is on or off.
/// * [onChanged] is called when the user toggles the switch on or off.
///
/// If you don't set these arguments you would
/// experiment errors related to animationController
/// states or any other undesirable behavior, please
/// don't forget to set them.
///
class TTSwitch extends StatefulWidget {
  @required
  final bool value;
  @required
  final Function(bool) onChanged;
  final String textOff;
  final String textOn;
  final Color colorOn;
  final Color colorOff;
  final double textSize;
  final double width;
  final Duration animationDuration;
  final Widget iconOn;
  final Widget iconOff;
  final Function onTap;
  final Function onDoubleTap;
  final Function onSwipe;

  TTSwitch(
      {this.value = false,
      this.textOff = "Off",
      this.textOn = "On",
      this.textSize = 14.0,
      this.width = 130,
      this.colorOn = Colors.green,
      this.colorOff = Colors.red,
      this.iconOff = const Icon(Icons.flag),
      this.iconOn = const Icon(Icons.check),
      this.animationDuration = const Duration(milliseconds: 600),
      this.onTap,
      this.onDoubleTap,
      this.onSwipe,
      this.onChanged});

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<TTSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  double value = 0.0;

  bool turnState;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: widget.animationDuration);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;
    _determine();
  }

  @override
  Widget build(BuildContext context) {
    Color transitionColor = Color.lerp(widget.colorOff, widget.colorOn, value);

    return GestureDetector(
      onDoubleTap: () {
        _action();
        if (widget.onDoubleTap != null) widget.onDoubleTap();
      },
      onTap: () {
        _action();
        if (widget.onTap != null) widget.onTap();
      },
      onPanEnd: (details) {
        _action();
        if (widget.onSwipe != null) widget.onSwipe();
        //widget.onSwipe();
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: widget.width,
        decoration: BoxDecoration(
          color: transitionColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(10 * value, 0), //original
              child: Opacity(
                opacity: (1 - value).clamp(0.0, 1.0),
                child: Container(
                  padding: EdgeInsets.only(right: 8),
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Text(
                    widget.textOff,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.textSize,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(10 * (1 - value), 0), //original
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  padding: EdgeInsets.only(left: 8),
                  alignment: Alignment.center,
                  height: 40,
                  width: widget.width - 55,
//                  child: AutoSizeText(
//                    widget.textOn,
//                    style: TextStyle(
//                      fontSize: widget.textSize,
//                      fontWeight: FontWeight.bold,
//                      color: Colors.white,
//                    ),
//                    maxLines: 3,
//                    minFontSize: 13,
//                    overflow: TextOverflow.ellipsis,
//                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset((widget.width - 50) * value, 0),
              child: Transform.rotate(
                angle: lerpDouble(0, 2 * pi, value),
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                          child: widget.iconOff,
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Stack(
                            children: <Widget>[
                              widget.iconOn,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _action() {
    _determine(changeState: true);
  }

  _determine({bool changeState = false}) {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        if (changeState) turnState = !turnState;
        (turnState)
            ? animationController.forward()
            : animationController.reverse();

        widget.onChanged(turnState);
      });
    });

  }
}
