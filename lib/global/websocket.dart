import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'myPlayer_state.dart';

//const String serverAddress = 'localhost:5000';
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
          'x': gameState['players'][myId.toString()]['position']['x'] +
              (mySpeed * cos(myAngle)),
          'y': gameState['players'][myId.toString()]['position']['x'] +
              (mySpeed * sin(myAngle))
        },
        'angle': myAngle,
        'object': holdingObject.name
      }
    }
  };
  channel.sink.add(jsonEncode(myPlayerState));
}
