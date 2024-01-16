import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/screens/initial_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pixel Adventure',
      home: InitialScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Flame.device.fullScreen();
//   await Flame.device.setLandscape();

//   PixelAdventure game = PixelAdventure();
//   runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
// }
