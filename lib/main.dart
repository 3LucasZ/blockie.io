import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'game_class.dart';

const String serverAddress = '192.168.1.144:5000';
var channel = WebSocketChannel.connect(Uri.parse('ws://' + serverAddress));
//Dummy gameState, placeholder
Map<String, dynamic> gameState = {
  'players': [
    {
      'position': {'x': 0, 'y': 0},
      'rotation': pi
    }
  ],
  'tiles': [
    ['wood', 'grass'],
    ['wood', 'grass']
  ]
};

int sendID = 0;
double dX = 0;
double dY = 0;
double theta = 0;
Vector2 myPosition = Vector2(0, 0);

void main() async {
  final myGame = MyGame();
  channel.stream.listen((message) {
    gameState = jsonDecode(message);
  });
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}
