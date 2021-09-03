import 'dart:math';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_flame_experiment/game_state_publisher.dart';
import 'dart:ui';
import 'constants.dart';
import 'main.dart';
import 'package:flame/game.dart';

class MyGame extends BaseGame with TapDetector {
  static final squarePaint = BasicPalette.white.paint();
  late final playerImage;
  late final grassTile;
  late final woodTile;

  @override
  Future<void> onLoad() async {
    playerImage = await images.load('player.png');
    grassTile = await images.load('grass_tile.jpeg');
    woodTile = await images.load('wood_tile.jpeg');
  }

  @override
  void update(double dt) {
    if (sendID == 0) {
      myPosition.x += SPEED * cos(theta);
      myPosition.y += SPEED * sin(theta);
      publishPlayerState();
    }
    sendID = (sendID + 1) % 10;
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
      canvas.translate(cx, cy);
      canvas.rotate(ctheta + pi / 2);
      canvas.drawImageRect(
          playerImage,
          Rect.fromLTWH(0, 0, 50, 50),
          Rect.fromCenter(
              center: Offset(0, 0), width: PLAYER_SIZE, height: PLAYER_SIZE),
          squarePaint);
      canvas.rotate(-1 * (ctheta + pi / 2));
      canvas.translate(-1 * cx, -1 * cy);
    }
  }

  @override
  void onTapDown(TapDownInfo event) {
    dX = event.eventPosition.global.x - myPosition.x;
    dY = event.eventPosition.global.y - myPosition.y;
    theta = atan(dY / dX);
    if (dX < 0) {
      theta += pi;
    }
  }
}
