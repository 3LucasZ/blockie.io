import 'dart:convert';
import 'dart:math';
import 'package:flutter_flame_experiment/game/game.dart';
import 'package:flutter_flame_experiment/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'config.dart';
import 'late.dart';
import 'myPlayer_state.dart';

var channel = WebSocketChannel.connect(Uri.parse('ws://' + serverAddress));
Map<String, dynamic> gameState = {};

void publishPlayerState() {
  double xToPublish;
  double yToPublish;
  if (repel) {
    xToPublish =
        myPlayer.position.x + getDirectionVector(myPositionAngle + pi, m).x;
    yToPublish =
        myPlayer.position.y + getDirectionVector(myPositionAngle + pi, m).y;
  } else {
    xToPublish = myPlayer.position.x + (mySpeed * cos(myPositionAngle));
    yToPublish = myPlayer.position.y + (mySpeed * sin(myPositionAngle));
  }
  double angleToPublish = myAngle;

  Map<String, dynamic> myPlayerState = {
    'type': 'playerState',
    'data': {
      myId.toString(): {
        'username': 'jeff',
        'position': {'x': xToPublish, 'y': yToPublish},
        'angle': angleToPublish,
        'object': holdingObject.name,
        'health': myHealth
      }
    }
  };
  channel.sink.add(jsonEncode(myPlayerState));
}

void publishNewObject(String name, double distanceFromPlayer) {
  Map<String, dynamic> newObject = {
    'type': 'newObject',
    'data': {
      'name': name,
      'position': {
        'x': myPlayer.position.x +
            getDirectionVector(myPlayer.angle, distanceFromPlayer).x,
        'y': myPlayer.position.y +
            getDirectionVector(myPlayer.angle, distanceFromPlayer).y
      },
      'angle': myPlayer.angle
    }
  };
  channel.sink.add(jsonEncode(newObject));
}
