import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_flame_experiment/global/myPlayer_state.dart';
import 'package:flutter_flame_experiment/global/websocket.dart';
import 'player.dart';
import 'package:flutter_flame_experiment/global/config.dart';

class MyGame extends BaseGame with HasDraggableComponents {
  final Map<String, dynamic> startingData;
  MyGame({required Map<String, dynamic> startingData})
      : startingData = startingData;

  @override
  Future<void> onLoad() async {
    //load assets
    await images.load('player.png');
    await images.load('grass_tile.jpeg');
    await images.load('wood_tile.jpeg');
    myId = startingData['id'];
    MyPlayer myPlayer = MyPlayer(
        sprite: Sprite(images.fromCache('player.png')),
        size: Vector2(50, 50),
        position: Vector2(0, 0),
        id: startingData['id'],
        gameRef: this);
    myPlayer.anchor = Anchor.center;
    add(myPlayer);

    for (int id in startingData['id_array']) {
      Player player = Player(
          sprite: Sprite(images.fromCache('player.png')),
          size: Vector2(50, 50),
          position: Vector2(0, 0),
          id: id,
          gameRef: this);
      player.anchor = Anchor.center;
      add(player);
    }
    print("Setup complete");
    camera.followComponent(myPlayer);
  }

  int publishCounter = 0;
  @override
  void update(dt) {
    super.update(dt);
    if (publishCounter == 0) {
      publishPlayerState();
    }
    publishCounter = (publishCounter + 1) % (60 / FPS).floor();
  }

  @override
  void onResize(Vector2 canvasSize) {
    super.onResize(canvasSize);
    double zoomScale;
    if (canvasSize.x > canvasSize.y) {
      zoomScale = canvasSize.x / 800;
    } else {
      zoomScale = canvasSize.y / 800;
    }
    camera.zoom = zoomScale;
  }

  void loadNewPlayer(int id) {
    Player player = Player(
        sprite: Sprite(images.fromCache('player.png')),
        size: Vector2(50, 50),
        position: Vector2(0, 0),
        id: id,
        gameRef: this);
    player.anchor = Anchor.center;
    add(player);
  }
}
