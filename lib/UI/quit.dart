import 'package:flutter/material.dart';
import 'package:flutter_flame_experiment/global/websocket.dart';

class QuitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Colors.red,
        ),
        child: CloseButton(
          color: Colors.white,
          onPressed: () {
            channel.sink.close();
          },
        ),
      ),
    );
  }
}
