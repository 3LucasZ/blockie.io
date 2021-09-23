import 'package:flutter_flame_experiment/global/myPlayer_state.dart';
import 'package:flutter_flame_experiment/global/websocket.dart';

class GameObjectMeta {
  final String name;
  final String image;
  final String type;
  final double height;
  final double width;
  final Function activate;
  GameObjectMeta(
      {required String name,
      required String image,
      required String type,
      required Function activate,
      double height = 50,
      double width = 50})
      : name = name,
        image = image,
        type = type,
        activate = activate,
        height = height,
        width = width;
}

//tiles
GameObjectMeta grassMeta = new GameObjectMeta(
  name: 'grass',
  image: 'grass_tile.jpeg',
  type: 'placeable',
  activate: () {
    publishNewObject('grass', 25);
    holdingObject = noneMeta;
  },
);
GameObjectMeta woodMeta = new GameObjectMeta(
  name: 'wood',
  image: 'wood_tile.jpeg',
  type: 'placeable',
  activate: () {
    publishNewObject('wood', 25);
    holdingObject = noneMeta;
  },
);
//misc
GameObjectMeta noneMeta = new GameObjectMeta(
  name: 'none',
  image: 'none.png',
  type: 'none',
  activate: () {},
);
//spinning
GameObjectMeta spikeMeta = new GameObjectMeta(
  name: 'spike',
  image: 'spike.png',
  type: 'placeable',
  activate: () {
    publishNewObject('spike', 50);
    holdingObject = noneMeta;
  },
);
//tools
GameObjectMeta bowMeta = new GameObjectMeta(
  name: 'bow',
  image: 'bow.png',
  type: 'tool',
  height: 50,
  width: 22,
  activate: () {
    publishNewObject('arrow', 30);
    print("Shot an arrow!");
  },
);
GameObjectMeta katanaMeta = new GameObjectMeta(
  name: 'katana',
  image: 'katana.png',
  type: 'tool',
  height: 120,
  width: 24,
  activate: () {},
);
List<int> swipeAnimationArray = [];
//projectiles
GameObjectMeta arrowMeta = new GameObjectMeta(
  name: 'arrow',
  image: 'arrow.png',
  type: 'projectile',
  height: 10,
  width: 50,
  activate: () {},
);
//food

GameObjectMeta getMetaByName(String name) {
  if (name == 'wood') {
    return woodMeta;
  } else if (name == 'grass') {
    return grassMeta;
  } else if (name == 'spike') {
    return spikeMeta;
  } else if (name == 'bow') {
    return bowMeta;
  } else if (name == 'arrow') {
    return arrowMeta;
  } else if (name == 'katana') {
    return katanaMeta;
  } else {
    return noneMeta;
  }
}
