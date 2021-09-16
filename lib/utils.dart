import 'dart:math';
import 'package:flame/components.dart';

Vector2 getDirectionVector(double angle, double distance) {
  return Vector2(cos(angle), sin(angle)) * distance;
}
