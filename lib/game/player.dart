import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'package:flutter_flame_experiment/global/style.dart';
import 'package:flutter_flame_experiment/global/websocket.dart';
import 'game_objects.dart';

class Player extends SpriteComponent {
  //attributes
  int id;
  BaseGame gameRef;
  GameObject object = none;
  late Map<String, dynamic> data;

  //rendering components
  SpriteComponent objectComponent = new SpriteComponent();
  TextComponent usernameComponent =
      new TextComponent('hello', textRenderer: usernamePaint);

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
      object = getObjectByName(data['object']);
      //render the username
      usernameComponent.position = Vector2(position.x, position.y - 50);
      //render the object being held
      if (object != none) {
        objectComponent.size = Vector2(50, 50);
        objectComponent.sprite = Sprite(gameRef.images.fromCache(object.image));
        objectComponent.angle = angle;
        objectComponent.position =
            Vector2(position.x + 50 * cos(angle), position.y + 50 * sin(angle));
      } else {
        objectComponent.size = Vector2(0, 0);
      }
    }
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
}
