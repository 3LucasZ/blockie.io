import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_flame_experiment/global/late.dart';
import 'package:flutter_flame_experiment/game/object_meta.dart';

import '../utils.dart';

List<String> tiles = ['wood', 'grass'];
List<String> rotatingSpikes = ['spike'];
List<String> projectiles = ['arrow'];

dynamic createObject(Map<String, dynamic> data) {
  if (tiles.contains(data['name'])) {
    return TileSprite(
        name: data['name'],
        x: data['position']['x'],
        y: data['position']['y'],
        spriteAngle: data['angle']);
  } else if (rotatingSpikes.contains(data['name'])) {
    return SpikeSprite(
        x: data['position']['x'],
        y: data['position']['y'],
        spriteAngle: data['angle']);
  } else if (projectiles.contains(data['name'])) {
    return ArrowSprite(
        x: data['position']['x'],
        y: data['position']['y'],
        spriteAngle: data['angle']);
  }
}

class TileSprite extends SpriteComponent with Hitbox, Collidable {
  double spriteAngle;
  TileSprite(
      {required String name,
      required double x,
      required double y,
      required double spriteAngle})
      : spriteAngle = spriteAngle,
        super(
          size: Vector2(50, 50),
          position: Vector2(x, y),
          sprite: Sprite(myGame.images.fromCache(getMetaByName(name).image)),
        );
  @override
  onLoad() {
    anchor = Anchor.center;
    angle = spriteAngle;
    final hitbox = HitboxRectangle(relation: Vector2(1.0, 1.0));
    addShape(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    //print("Collision detected with: " + other.runtimeType.toString());
  }

  @override
  void onCollisionEnd(Collidable other) {
    print("Collision ended!");
  }
}

class SpikeSprite extends SpriteComponent with Hitbox, Collidable {
  double spriteAngle;
  SpikeSprite(
      {required double x, required double y, required double spriteAngle})
      : spriteAngle = spriteAngle,
        super(
          size: Vector2(50, 50),
          position: Vector2(x, y),
          sprite: Sprite(myGame.images.fromCache(spikeMeta.image)),
        );
  @override
  onLoad() {
    super.onLoad();
    anchor = Anchor.center;
    angle = spriteAngle;
    final hitbox = HitboxCircle(definition: 1);
    addShape(hitbox);
  }

  @override
  update(dt) {
    super.update(dt);
    angle += 1;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    //print("Collision detected with: " + other.runtimeType.toString());
  }

  @override
  void onCollisionEnd(Collidable other) {
    //print("Collision ended!");
  }
}

class ArrowSprite extends SpriteComponent with Hitbox, Collidable {
  double spriteAngle;
  List<String> doNotCollide = ['ArrowSprite'];
  ArrowSprite(
      {required double x, required double y, required double spriteAngle})
      : spriteAngle = spriteAngle,
        super(
          size: Vector2(50, 10),
          position: Vector2(x, y),
          sprite: Sprite(myGame.images.fromCache(arrowMeta.image)),
        );
  @override
  onLoad() {
    super.onLoad();
    anchor = Anchor.center;
    angle = spriteAngle;
    final hitbox = HitboxRectangle(relation: Vector2(1, 1));
    addShape(hitbox);
  }

  @override
  update(dt) {
    super.update(dt);
    position += getDirectionVector(angle, 3);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (!doNotCollide.contains(other.runtimeType.toString())) {
      remove();
    }
  }
}
