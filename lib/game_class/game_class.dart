import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flutter_flame_experiment/game_state_publisher.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../global_vars.dart';

//global myPlayer data
Vector2 myPosition = Vector2(500.0, 500.0);
double myTheta = 0.0;
String selectedObject = 'wood';

//initialize global assets
late final playerImage;
late final grassTile;
late final woodTile;

class MyGame extends BaseGame with TapDetector {
  static final squarePaint = BasicPalette.white.paint();

  //additional myPlayer data
  int sendID = 0;
  Vector2 myTarget = Vector2(0.0, 0.0);
  Vector2 mySpeed = Vector2(0.0, 0.0);

  @override
  Future<void> onLoad() async {
    //define assets
    playerImage = await images.load('player.png');
    grassTile = await images.load('grass_tile.jpeg');
    woodTile = await images.load('wood_tile.jpeg');
    //camera.setRelativeOffset(Anchor.center);
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
      //constrain myPosition to be in bounds
      myPosition.x = min(2100, max(400, myPosition.x));
      myPosition.y = min(2100, max(400, myPosition.y));
      publishPlayerState();
    }
    sendID = (sendID + 1) % UPDATE_INTERVAL;
  }

  @override
  void render(Canvas canvas) {
    renderSkew.x = -1 * (myPosition.x - screenSize.width / 2);
    renderSkew.y = -1 * (myPosition.y - screenSize.height / 2);
    canvas.translate(renderSkew.x, renderSkew.y);
    List<dynamic> tiles = gameState['tiles'];
    for (int y = 0; y < tiles.length; y++) {
      List<dynamic> tilesY = tiles[y];
      for (int x = 0; x < tilesY.length; x++) {
        canvas.drawImageRect(
            (tilesY[x] == 'wood') ? woodTile : grassTile,
            Rect.fromLTWH(0, 0, 50, 50),
            Rect.fromCenter(
                center: Offset((x + gameState['meta']['x']) * TILE_SIZE,
                    (y + gameState['meta']['y']) * TILE_SIZE),
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
      //if player is holding a block, render block
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
      canvas.rotate(-1 * ctheta);
      //paint username on top of player
      usernamePaint.render(
          canvas, player['username'], Vector2(0, USERNAME_OFFSET),
          anchor: Anchor.bottomCenter);
      canvas.translate(-1 * cx, -1 * cy);
    }
    canvas.translate(-1 * renderSkew.x, -1 * renderSkew.y);
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
      myTarget.x = event.eventPosition.global.x - renderSkew.x;
      myTarget.y = event.eventPosition.global.y - renderSkew.y;
      myTheta = atan((myTarget.y - myPosition.y) / (myTarget.x - myPosition.x));
      if (myPosition.x > myTarget.x) {
        myTheta -= pi;
      }
      mySpeed.x = SPEED * cos(myTheta);
      mySpeed.y = SPEED * sin(myTheta);
    }
  }
}
