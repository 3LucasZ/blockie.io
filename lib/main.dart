import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'UI/joystick2.dart';
import 'UI/quit.dart';
import 'game/game.dart';
import 'UI/inventory.dart';
import 'UI/joystick.dart';
import 'global/late.dart';
import 'global/websocket.dart';

void main() async {
  channel.stream.listen((message) async {
    Map<String, dynamic> messageDecoded = jsonDecode(message);
    if (messageDecoded['type'] == 'startingData') {
      myGame = MyGame(startingData: messageDecoded['data']);
      print('starting data received, starting game...');
      print(messageDecoded['data']);
      runApp(MyApp());
    } else if (messageDecoded['type'] == 'newPlayer') {
      myGame.loadNewPlayer(messageDecoded['data']);
      print('new player received');
    } else if (messageDecoded['type'] == 'removePlayer') {
      print('remove player received');
    } else if (messageDecoded['type'] == 'playersData') {
      gameState = messageDecoded['data'];
      if (verboseCounter == 0) {
        print(gameState);
      }
      verboseCounter = (verboseCounter + 1) % 300;
    } else if (messageDecoded['type'] == 'newObject') {
      print('new object received');
      myGame.loadNewObject(messageDecoded['data']);
    } else {
      print("data of type: " + messageDecoded['type'] + " is not supported.");
    }
    //print('received: ' + messageDecoded.toString());
  });
}

int verboseCounter = 0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            MouseRegion(
              child: GameWidget(game: myGame),
              onHover: processMouse,
            ),
            InventoryBar(),
            Joystick(),
            Joystick2(),
            QuitButton(),
          ],
        ),
      ),
    );
  }
}
