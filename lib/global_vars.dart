import 'package:flame/components.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

//const String serverAddress = '192.168.1.144:5000';
const String serverAddress = 'localhost:5000';
var channel = WebSocketChannel.connect(Uri.parse('ws://' + serverAddress));
var screenSize;
//global game state, received from server
Map<String, dynamic> gameState = {};
Vector2 renderSkew = Vector2(0, 0);
