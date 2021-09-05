import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'game_class.dart';
import 'inventory_bar.dart';

//websocket server setup
//const String serverAddress = '192.168.1.144:5000';
const String serverAddress = 'localhost:5000';
var channel = WebSocketChannel.connect(Uri.parse('ws://' + serverAddress));
var screenSize;
//global game state, received from server
Map<String, dynamic> gameState = {};

void main() async {
  final myGame = MyGame();
  channel.stream.listen((message) {
    gameState = jsonDecode(message);
  });
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            GameWidget(game: myGame),
            InventoryBar(),
          ],
        ),
      ),
    ),
  );
}
