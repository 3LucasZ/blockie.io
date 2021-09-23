import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_flame_experiment/game/selected.dart';
import 'package:flutter_flame_experiment/global/myPlayer_state.dart';
import 'package:flutter_flame_experiment/global/websocket.dart';
import 'package:flutter_flame_experiment/style/palette.dart';
import 'package:flutter_flame_experiment/game/object_meta.dart';

import '../utils.dart';
import 'game_objects/game_objects.dart';

class Player extends SpriteComponent with Hitbox, Collidable {
  //attributes
  int id;
  BaseGame gameRef;
  late Map<String, dynamic> serverData;
  double health = 100;

  //rendering components
  late SelectedObject objectComponent;
  late TextComponent usernameComponent;

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
    objectComponent =
        new SelectedObject(myPlayerParent: false, positionRef: position);
    usernameComponent =
        new TextComponent('hello', textRenderer: Palette.usernamePaint);
    objectComponent.anchor = Anchor.center;
    usernameComponent.anchor = Anchor.bottomCenter;
    gameRef.add(objectComponent);
    gameRef.add(usernameComponent);
    final hitbox = HitboxCircle(definition: 0.8);
    addShape(hitbox);
    //debugMode = true;
  }

  bool hasReceived = false;
  @override
  void update(double dt) {
    super.update(dt);
    if (gameState['players'][id.toString()] != null) {
      hasReceived = true;
    }
    if (hasReceived) {
      //update player data
      if (gameState['players'][id.toString()] != null) {
        serverData = gameState['players'][id.toString()];
        position.x = serverData['position']['x'];
        position.y = serverData['position']['y'];
        angle = serverData['angle'];
        health = serverData['health'];
        objectComponent.changeMeta(getMetaByName(serverData['object']));
        //render the username
        usernameComponent.position = Vector2(position.x, position.y - 20);
        //update
        objectComponent.angle = angle;
        objectComponent.update(dt);
      } else {
        print("No data received on player " + id.toString() + "... Removing");
        objectComponent.remove();
        usernameComponent.remove();
        remove();
      }
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
    objectComponent.remove();
    objectComponent =
        new SelectedObject(myPlayerParent: true, positionRef: position);
    gameRef.add(objectComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    switch (other.runtimeType) {
      case SpikeSprite:
        print('SpikeSprite was hit');
        myHealth -= 0.1;
        break;
      case ArrowSprite:
        print('Arrow was hit');
        myHealth -= 10;
        break;
      case TileSprite:
        print("Map Object was hit");
        repel = true;
        Vector2 u = position - other.position;
        Vector2 v = getDirectionVector(-1 * myPositionAngle, 1);
        double a = (pow(u.x, 2) + pow(u.y, 2)).toDouble();
        double b = (2 * u.x * v.x + 2 * u.y * v.y);
        double c = (pow(u.x, 2) + pow(u.y, 2) - pow(36 + 50, 2)).toDouble();
        m = (-1 * b + sqrt(pow(b, 2) - 4 * a * c)) / (2 * a);
        print(m);
        break;
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    repel = false;
  }
}
