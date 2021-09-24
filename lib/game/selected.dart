import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_flame_experiment/game/player.dart';
import 'package:flutter_flame_experiment/global/my_player_state.dart';

import '../utils.dart';
import 'object_meta.dart';

class SelectedObject extends SpriteComponent with Hitbox, Collidable {
  GameObjectMeta meta = noneMeta;
  bool myPlayerParent;
  Vector2 positionRef;
  SelectedObject({required this.myPlayerParent, required this.positionRef})
      : super();

  void changeMeta(GameObjectMeta newMeta) {
    meta = newMeta;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    final hitbox = HitboxRectangle(relation: Vector2(1, 1));
    addShape(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    size = Vector2(meta.width, meta.height);
    sprite = Sprite(Flame.images.fromCache(meta.image));
    position = positionRef + getDirectionVector(angle, 25 + meta.width / 2);
    if (meta.type == 'tool') {
      position += getDirectionVector(angle + 90, 40);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (myPlayerParent) {
      if (meta.type == 'placeable') {
        switch (other.runtimeType) {
          case (SelectedObject):
          case (MyPlayer):
            break;
          default:
            canPlace = false;
          //print(other.runtimeType);
        }
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    if (myPlayerParent) {
      canPlace = true;
    }
  }
}
