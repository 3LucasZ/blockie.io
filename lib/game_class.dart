import 'dart:math';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flutter_flame_experiment/game_state_publisher.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';
import 'package:flame/game.dart';

Vector2 myPosition = Vector2(100.0, 100.0);
String selectedObject = 'wood';
double myTheta = 0.0;

late final playerImage;
late final grassTile;
late final woodTile;

class MyGame extends BaseGame with TapDetector {
  static final squarePaint = BasicPalette.white.paint();
  //declare assets

  int sendID = 0;
  Vector2 myTarget = Vector2(0.0, 0.0);
  Vector2 mySpeed = Vector2(0.0, 0.0);

  @override
  Future<void> onLoad() async {
    //define assets
    playerImage = await images.load('player.png');
    grassTile = await images.load('grass_tile.jpeg');
    woodTile = await images.load('wood_tile.jpeg');
  }

  @override
  void update(double dt) {
    if (sendID == 0) {
      if (sqrt((myPosition.x - myTarget.x) * (myPosition.x - myTarget.x) +
              (myPosition.y - myTarget.y) * (myPosition.y - myTarget.y)) >
          SPEED) {
        myPosition.x += mySpeed.x;
        myPosition.y += mySpeed.y;
      } else {
        myPosition.x = myTarget.x;
        myPosition.y = myTarget.y;
      }
      publishPlayerState();
    }
    sendID = (sendID + 1) % UPDATE_INTERVAL;
  }

  @override
  void render(Canvas canvas) {
    List<dynamic> tiles = gameState['tiles'];
    for (int r = 0; r < tiles.length; r++) {
      List<dynamic> tilesR = tiles[r];
      for (int c = 0; c < tilesR.length; c++) {
        canvas.drawImageRect(
            (tilesR[c] == 'wood') ? woodTile : grassTile,
            Rect.fromLTWH(0, 0, 50, 50),
            Rect.fromCenter(
                center: Offset(r * TILE_SIZE, c * TILE_SIZE),
                width: TILE_SIZE,
                height: TILE_SIZE),
            squarePaint);
      }
    }
    for (Map<String, dynamic> player in gameState['players']) {
      double cx = player['position']['x'];
      double cy = player['position']['y'];
      double ctheta = player['rotation'];
      String blockName = player['selected'];
      var block;
      if (blockName == 'wood') {
        block = woodTile;
      } else if (blockName == 'grass') {
        block = grassTile;
      }

      canvas.translate(cx, cy);
      canvas.rotate(ctheta);
      canvas.drawImageRect(
          playerImage,
          Rect.fromLTWH(0, 0, 50, 50),
          Rect.fromCenter(
              center: Offset(0, 0), width: PLAYER_SIZE, height: PLAYER_SIZE),
          squarePaint);
      if (block != null) {
        canvas.drawImageRect(
            block,
            Rect.fromLTWH(0, 0, 50, 50),
            Rect.fromCenter(
                center: Offset(SELECTED_OFFSET, 0),
                width: TILE_SIZE,
                height: TILE_SIZE),
            squarePaint);
      }
      canvas.restore();
    }
  }

  @override
  void onTapDown(TapDownInfo event) {
    if (selectedObject != 'none') {
      int placementX =
          ((myPosition.x + cos(myTheta) * SELECTED_OFFSET) / TILE_SIZE).round();
      int placementY =
          ((myPosition.y + sin(myTheta) * SELECTED_OFFSET) / TILE_SIZE).round();
      publishNewTile(placementX, placementY, selectedObject);
    } else {
      myTarget.x = event.eventPosition.global.x;
      myTarget.y = event.eventPosition.global.y;
      myTheta = atan((myTarget.y - myPosition.y) / (myTarget.x - myPosition.x));
      if (myPosition.x > myTarget.x) {
        myTheta -= pi;
      }
      mySpeed.x = SPEED * cos(myTheta);
      mySpeed.y = SPEED * sin(myTheta);
    }
  }
}
