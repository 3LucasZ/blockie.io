//distance player moves per update function
import 'package:flame/components.dart';

const double SPEED = 6;
const double TILE_SIZE = 50;
const double SELECTED_OFFSET = 40;
const double PLAYER_SIZE = 50;
const int MAP_BLOCK_WIDTH = 50;
const int MAP_BLOCK_HEIGHT = 50;
const int SNAPSHOT_BLOCK_WIDTH = 16;
const int SNAPSHOT_BLOCK_HEIGHT = 16;
// 60/UPDATE_INTERVAL player position updates per second
const int UPDATE_INTERVAL = 12;
const double USERNAME_OFFSET = -25;
TextPaint usernamePaint = TextPaint(
  config: TextPaintConfig(
    fontSize: 15.0,
    fontFamily: 'Arial',
  ),
);
