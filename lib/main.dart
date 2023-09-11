import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
// Teste info 
  PixelAdventure game = PixelAdventure();
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}
