import 'package:flame/components.dart';
import 'package:flutter_flame_experiment/game/game_objects/game_objects.dart';
import 'package:flutter_flame_experiment/game/player.dart';
import 'package:flutter_flame_experiment/game/object_meta.dart';

GameObjectMeta holdingObject = noneMeta;
double myAngle = 0;
double mySpeed = 0;
double myMaxSpeed = 3;
double myHealth = 100;
bool canPlace = true;
/*List<Vector2> myPreviousPositions = [
  Vector2(0, 0),
  Vector2(0, 0),
  Vector2(0, 0)
];

 */
int myId = 0;
