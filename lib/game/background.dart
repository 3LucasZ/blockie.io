import 'package:flame/flame.dart';
import 'package:flame/layers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_experiment/style/palette.dart';

class BackgroundLayer extends PreRenderedLayer {
  BackgroundLayer();
  @override
  void drawLayer() {
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < 5; c++) {
        /*canvas.drawImageRect(
            Flame.images.fromCache('grass_tile.jpeg'),
            Rect.largest,
            Rect.fromCenter(
                center: Offset(50.0 * r, 50.0 * c), width: 50, height: 50),
            Palette.green.paint());

         */
        canvas.drawImage(Flame.images.fromCache('grass_tile.jpeg'),
            Offset(50.0 * r, 50.0 * c), Palette.green.paint());
      }
    }
  }
}
