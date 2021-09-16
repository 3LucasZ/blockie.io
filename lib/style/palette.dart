import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Palette {
  static PaletteEntry white = BasicPalette.white;
  static PaletteEntry red = PaletteEntry(Color(0xFFAC3232));
  static PaletteEntry red2 = PaletteEntry(Color(0xFFCC5151));
  static PaletteEntry yellow = PaletteEntry(Color(0xFFDA9A00));
  static PaletteEntry grey = PaletteEntry(Color(0xFF404040));
  static PaletteEntry grey2 = PaletteEntry(Color(0xFF3D3F42));
  static PaletteEntry green = PaletteEntry(Color(0xFF54a286));
  static PaletteEntry green2 = PaletteEntry(Color(0xFF8ECC51));
  static TextPaint usernamePaint = TextPaint(
    config: TextPaintConfig(
      color: Colors.white,
      fontSize: 15.0,
      fontFamily: 'Awesome Font',
    ),
  );
}
