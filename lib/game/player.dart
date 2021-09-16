import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_flame_experiment/global/myPlayer_state.dart';
import 'package:flutter_flame_experiment/global/websocket.dart';
import 'package:flutter_flame_experiment/style/palette.dart';
import 'package:flutter_flame_experiment/game/object_meta.dart';

class Player extends SpriteComponent with Hitbox, Collidable {
  //attributes
  int id;
  BaseGame gameRef;
  GameObjectMeta object = noneMeta;
  late Map<String, dynamic> data;
  double health = 100;

  //rendering components
  SpriteComponent objectComponent = new SpriteComponent();
  TextComponent usernameComponent =
      new TextComponent('hello', textRenderer: Palette.usernamePaint);

  Player(
      {required Sprite sprite,
      required Vector2 position,
      required Vector2 size,
      required int id,
      required BaseGame gameRef})
      : id = id,
        gameRef = gameRef,
        super(sprite: sprite, position: position, size: size);

  @override
  Future onLoad() async {
    objectComponent.anchor = Anchor.center;
    usernameComponent.anchor = Anchor.center;
    gameRef.add(objectComponent);
    gameRef.add(usernameComponent);
    final hitbox = HitboxCircle(definition: 1);
    addShape(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    //update player data
    if (gameState['players'][id.toString()] != null) {
      data = gameState['players'][id.toString()];
      position.x = data['position']['x'];
      position.y = data['position']['y'];
      angle = data['angle'];
      health = data['health'];
      object = getMetaByName(data['object']);
      //render the username
      usernameComponent.position = Vector2(position.x, position.y - 50);
      //render the object being held
      if (object != noneMeta) {
        objectComponent.size = Vector2(50, 50);
        objectComponent.sprite = Sprite(gameRef.images.fromCache(object.image));
        objectComponent.angle = angle;
        objectComponent.position =
            Vector2(position.x + 50 * cos(angle), position.y + 50 * sin(angle));
      } else {
        objectComponent.size = Vector2(0, 0);
      }
    } else {
      remove();
    }
  }

  @override
  render(Canvas c) {
    //draw health bar
    c.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(position.x - 25, position.y + 30, 50, 5),
            Radius.circular(2.5)),
        Palette.grey2.paint());
    if (health >= 0) {
      c.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                  position.x - 25, position.y + 30, 50 * (health / 100), 5),
              Radius.circular(2.5)),
          health >= 66
              ? Palette.green2.paint()
              : health >= 33
                  ? Palette.yellow.paint()
                  : Palette.red2.paint());
    }
    super.render(c);
  }
}

class MyPlayer extends Player {
  MyPlayer(
      {required Sprite sprite,
      required Vector2 position,
      required Vector2 size,
      required int id,
      required BaseGame gameRef})
      : super(
            sprite: sprite,
            position: position,
            size: size,
            id: id,
            gameRef: gameRef);
  @override
  Future onLoad() async {
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    print(other.runtimeType);
    if (other.runtimeType.toString() == 'SpikeSprite') {
      myHealth -= 0.1;
    } else if (other.runtimeType.toString() == 'ArrowSprite') {
      myHealth -= 10;
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    //print("Collision ended!");
  }
}
