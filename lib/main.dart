import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/game.dart';
import 'UI/inventory.dart';
import 'UI/joystick.dart';
import 'global/websocket.dart';

late final MyGame myGame;
void main() async {
  channel.stream.listen((message) async {
    Map<String, dynamic> messageDecoded = jsonDecode(message);
    if (messageDecoded['type'] == 'startingData') {
      myGame = MyGame(startingData: messageDecoded['data']);
      runApp(MyApp());
    } else if (messageDecoded['type'] == 'newPlayer') {
      myGame.loadNewPlayer(messageDecoded['data']);
    } else if (messageDecoded['type'] == 'removePlayer') {
    } else if (messageDecoded['type'] == 'gameState') {
      gameState = messageDecoded['data'];
    } else {
      print("data of type: " + messageDecoded['type'] + " is not supported.");
    }
    //print('received: ' + messageDecoded.toString());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            GameWidget(game: myGame),
            InventoryBar(),
            Joystick(),
          ],
        ),
      ),
    );
  }
}
