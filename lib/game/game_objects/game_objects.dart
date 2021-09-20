import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flutter_flame_experiment/game/selected.dart';
import 'package:flutter_flame_experiment/global/late.dart';
import 'package:flutter_flame_experiment/game/object_meta.dart';

import '../../utils.dart';

List<String> tiles = ['wood', 'grass'];
List<String> rotatingSpikes = ['spike'];
List<String> projectiles = ['arrow'];

dynamic createObject(Map<String, dynamic> data) {
  if (tiles.contains(data['name'])) {
    return TileSprite(data: data);
  } else if (rotatingSpikes.contains(data['name'])) {
    return SpikeSprite(data: data);
  } else if (projectiles.contains(data['name'])) {
    //print('Creating arrow');
    return ArrowSprite(data: data);
  }
}

class ObjectSprite extends SpriteComponent with Hitbox, Collidable {
  Map<String, dynamic> data;
  late GameObjectMeta meta;
  ObjectSprite({required Map<String, dynamic> data})
      : data = data,
        super();
  @override
  onLoad() {
    meta = getMetaByName(data['name']);
    size = Vector2(meta.width, meta.height);
    position = Vector2(data['position']['x'], data['position']['y']);
    sprite = Sprite(Flame.images.fromCache(meta.image));
    angle = data['angle'];
  }
}

class TileSprite extends ObjectSprite {
  TileSprite({required Map<String, dynamic> data}) : super(data: data);
  @override
  onLoad() {
    super.onLoad();
    anchor = Anchor.centerLeft;
    final hitbox = HitboxRectangle(relation: Vector2(1.0, 1.0));
    addShape(hitbox);
  }
}

class SpikeSprite extends ObjectSprite {
  SpikeSprite({required Map<String, dynamic> data}) : super(data: data);

  @override
  onLoad() {
    super.onLoad();
    anchor = Anchor.center;
    final hitbox = HitboxCircle(definition: 1);
    addShape(hitbox);
  }

  @override
  update(dt) {
    super.update(dt);
    angle += 1;
  }
}

class ArrowSprite extends ObjectSprite {
  double lifetime = 0;
  ArrowSprite({required Map<String, dynamic> data}) : super(data: data);

  @override
  onLoad() {
    super.onLoad();
    anchor = Anchor.centerLeft;
    final hitbox = HitboxRectangle(relation: Vector2(1, 1));
    addShape(hitbox);
    //print("arrow created successfully");
  }

  @override
  update(dt) {
    super.update(dt);
    position += getDirectionVector(angle, 180 * dt);
    lifetime += dt;
    if (lifetime > 1) {
      remove();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    switch (other.runtimeType) {
      case ArrowSprite:
      case SelectedObject:
        break;
      default:
        //print("Hit an object: ," + other.runtimeType.toString());
        remove();
    }
  }
}
