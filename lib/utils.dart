import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

Vector2 getDirectionVector(double angle, double distance) {
  return Vector2(cos(angle), sin(angle)) * distance;
}

Future<void> loadAssets() async {
  await Flame.images.load('player.png');
  await Flame.images.load('grass_tile.jpeg');
  await Flame.images.load('wood_tile.jpeg');
  await Flame.images.load('spike.png');
  await Flame.images.load('arrow.png');
  await Flame.images.load('none.png');
  await Flame.images.load('katana.png');
  await Flame.images.load('bow.png');
}
