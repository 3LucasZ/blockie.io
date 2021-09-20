import 'dart:convert';
import 'dart:math';
import 'package:flutter_flame_experiment/game/game.dart';
import 'package:flutter_flame_experiment/utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'late.dart';
import 'myPlayer_state.dart';

//const String serverAddress = 'localhost:5000';
//const String serverAddress = '192.168.1.139:5000';
const String serverAddress = '192.168.1.144:5000';
var channel = WebSocketChannel.connect(Uri.parse('ws://' + serverAddress));
Map<String, dynamic> gameState = {};

void publishPlayerState() {
  Map<String, dynamic> myPlayerState = {
    'type': 'playerState',
    'data': {
      myId.toString(): {
        'username': 'jeff',
        'position': {
          'x': myPlayer.position.x + (mySpeed * cos(myAngle)),
          'y': myPlayer.position.y + (mySpeed * sin(myAngle))
        },
        'angle': myAngle,
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
      'angle': myAngle
    }
  };
  channel.sink.add(jsonEncode(newObject));
}
