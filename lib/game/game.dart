import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/keyboard.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flame_experiment/game/game_objects/game_objects.dart';
import 'package:flutter_flame_experiment/global/late.dart';
import 'package:flutter_flame_experiment/global/myPlayer_state.dart';
import 'package:flutter_flame_experiment/global/websocket.dart';
import '../utils.dart';
import 'background.dart';
import 'object_meta.dart';
import 'player.dart';
import 'package:flutter_flame_experiment/global/config.dart';

class MyGame extends BaseGame with TapDetector, HasCollidables, KeyboardEvents {
  final Map<String, dynamic> startingData;
  //late BackgroundLayer backgroundLayer;
  @override
  Color backgroundColor() => Colors.green;

  MyGame({required Map<String, dynamic> startingData})
      : startingData = startingData;

  @override
  Future<void> onLoad() async {
    await loadAssets();
    //backgroundLayer = BackgroundLayer();
    myId = startingData['id'];
    myPlayer = MyPlayer(
        sprite: Sprite(Flame.images.fromCache('player.png')),
        size: Vector2(50, 50),
        position: Vector2(0, 0),
        id: startingData['id'],
        gameRef: this);
    myPlayer.anchor = Anchor.center;
    add(myPlayer);

    for (int id in startingData['id_array']) {
      loadNewPlayer(id);
    }
    for (Map<String, dynamic> objectData in startingData['objects']) {
      loadNewObject(objectData);
    }
    print("Setup complete");
    camera.followComponent(myPlayer);
  }

  int publishCounter = 0;
  @override
  void update(dt) {
    super.update(dt);
    if (publishCounter == 0) {
      publishPlayerState();
    }
    publishCounter = (publishCounter + 1) % (60 / FPS).floor();
  }

  @override
  void render(Canvas c) {
    //backgroundLayer.render(c);
    super.render(c);
  }

  @override
  void onResize(Vector2 canvasSize) {
    super.onResize(canvasSize);
    double zoomScale;
    if (canvasSize.x > canvasSize.y) {
      zoomScale = canvasSize.x / 800;
    } else {
      zoomScale = canvasSize.y / 800;
    }
    camera.zoom = zoomScale;
  }

  void loadNewPlayer(int id) {
    Player player = Player(
        sprite: Sprite(Flame.images.fromCache('player.png')),
        size: Vector2(50, 50),
        position: Vector2(0, 0),
        id: id,
        gameRef: this);
    player.anchor = Anchor.center;
    add(player);
  }

  void loadNewObject(Map<String, dynamic> data) {
    print(data);
    dynamic object = createObject(data);
    add(object);
  }

  @override
  void onTapDown(TapDownInfo event) {
    if (holdingObject.type == 'placeable') {
      if (canPlace) {
        holdingObject.activate();
      }
    } else {
      holdingObject.activate();
    }
  }

  @override
  void onKeyEvent(RawKeyEvent event) {
    final isKeyDown = event is RawKeyDownEvent;
    if (isKeyDown) {
      mySpeed = myMaxSpeed;
      //HANDLE WASD PRESSES -> PLAYER POSITION ROTATION
      if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        myPositionAngle = -1 * pi / 2;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        myPositionAngle = 0;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.keyS) {
        myPositionAngle = pi / 2;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.keyA) {
        myPositionAngle = -1 * pi;
      }
    } else {
      mySpeed = 0;
    }
  }
}
