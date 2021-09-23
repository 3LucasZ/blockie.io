import 'package:flame/components.dart';
import 'package:flutter_flame_experiment/game/game_objects/game_objects.dart';
import 'package:flutter_flame_experiment/game/player.dart';
import 'package:flutter_flame_experiment/game/object_meta.dart';

GameObjectMeta holdingObject = noneMeta;
double myPositionAngle = 0;
double myAngle = 0;
double mySpeed = 0;
double myMaxSpeed = 3;
double myHealth = 100;
bool canPlace = true;
bool repel = false;
double m = 0;
/*List<Vector2> myPreviousPositions = [
  Vector2(0, 0),
  Vector2(0, 0),
  Vector2(0, 0)
];

 */
int myId = 0;
