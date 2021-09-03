import 'dart:convert';
import 'main.dart';

void publishPlayerState() {
  Map<String, dynamic> myPlayerState = {
    'position': {'x': myPosition.x, 'y': myPosition.y},
    'rotation': theta
  };
  channel.sink.add(jsonEncode(myPlayerState));
}
