import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_flame_experiment/global/my_player_state.dart';

class Joystick extends StatefulWidget {
  const Joystick({Key? key}) : super(key: key);

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset position = Offset(15, 25);
  Offset outerSize = Offset(100, 100);
  Offset innerSize = Offset(50, 50);
  Offset delta = Offset.zero;

  void updateDelta(Offset newDelta) {
    myPositionAngle = delta.direction;
    setState(() {
      delta = newDelta;
    });
  }

  void calculateDelta(Offset offset) {
    Offset newDelta = offset - (position + outerSize / 2);
    updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(outerSize.dx / 2, newDelta.distance),
      ),
    );
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    outerSize = Offset(screenSize.width / 7, screenSize.width / 7);
    innerSize = Offset(screenSize.width / 14, screenSize.width / 14);
    return Positioned(
      left: position.dx,
      bottom: position.dy,
      child: Container(
        width: outerSize.dx,
        height: outerSize.dx,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Color(0xcc2B3E47),
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          child: Center(
            child: Transform.translate(
              offset: delta,
              child: Container(
                width: innerSize.dx,
                height: innerSize.dy,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Color(0xcc526A77),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          onPanStart: onDragStart,
          onPanUpdate: onDragUpdate,
          onPanEnd: onDragEnd,
        ),
      ),
    );
  }

  void onDragStart(DragStartDetails d) {
    mySpeed = myMaxSpeed;
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    mySpeed = myMaxSpeed;
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    mySpeed = 0;
    updateDelta(Offset.zero);
  }
}
