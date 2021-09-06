import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game_class/game_class.dart';
import 'global_vars.dart';
import 'inventory_bar.dart';

void main() async {
  final myGame = MyGame();
  channel.stream.listen((message) {
    gameState = jsonDecode(message);
    //print(gameState);
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
