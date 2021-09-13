class GameObject {
  final String name;
  final String image;
  GameObject({
    required String name,
    required String image,
  })  : name = name,
        image = image;
}

GameObject grass = new GameObject(
  name: 'grass',
  image: 'grass_tile.jpeg',
);
GameObject wood = new GameObject(
  name: 'wood',
  image: 'wood_tile.jpeg',
);
GameObject none = new GameObject(
  name: 'none',
  image: 'none',
);

GameObject getObjectByName(String name) {
  if (name == 'wood') {
    return wood;
  } else if (name == 'grass') {
    return grass;
  } else {
    return none;
  }
}
