import 'package:flame/components.dart';
import 'global_vars.dart';

Vector2 getGlobalCoord(Vector2 localCoord) {
  return Vector2(localCoord.x + renderSkew.x, localCoord.y + renderSkew.y);
}
