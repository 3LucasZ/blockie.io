import 'dart:convert';
import 'game_class/game_class.dart';
import 'global_vars.dart';

void publishPlayerState() {
  Map<String, dynamic> myPlayerState = {
    'type': 'playerState',
    'data': {
      'username': 'jeff',
      'position': {'x': myPosition.x, 'y': myPosition.y},
      'rotation': myTheta,
      'selected': selectedObject
    }
  };
  channel.sink.add(jsonEncode(myPlayerState));
}

void publishNewTile(int x, int y, String type) {
  Map<String, dynamic> newTile = {
    'type': 'newTile',
    'data': {
      'tile': type,
      'position': {'x': x, 'y': y},
    }
  };
  channel.sink.add(jsonEncode(newTile));
}
