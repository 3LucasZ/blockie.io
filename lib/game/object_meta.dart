class GameObjectMeta {
  final String name;
  final String image;
  final String type;
  GameObjectMeta(
      {required String name, required String image, required String type})
      : name = name,
        image = image,
        type = type;
}

//tiles
GameObjectMeta grassMeta = new GameObjectMeta(
  name: 'grass',
  image: 'grass_tile.jpeg',
  type: 'placeable',
);
GameObjectMeta woodMeta = new GameObjectMeta(
  name: 'wood',
  image: 'wood_tile.jpeg',
  type: 'placeable',
);
//misc
GameObjectMeta noneMeta = new GameObjectMeta(
  name: 'none',
  image: 'none',
  type: 'none',
);
//spinning
GameObjectMeta spikeMeta = new GameObjectMeta(
  name: 'spike',
  image: 'spike.png',
  type: 'placeable',
);
//tools
GameObjectMeta bowMeta = new GameObjectMeta(
  name: 'bow',
  image: 'bow.png',
  type: 'tool',
);
//projectiles
GameObjectMeta arrowMeta = new GameObjectMeta(
  name: 'arrow',
  image: 'arrow.png',
  type: 'projectile',
);
//food

GameObjectMeta getMetaByName(String name) {
  if (name == 'wood') {
    return woodMeta;
  } else if (name == 'grass') {
    return grassMeta;
  } else if (name == 'spike') {
    return spikeMeta;
  } else {
    return noneMeta;
  }
}
