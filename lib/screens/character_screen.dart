import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/menu_button.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/initial_screen.dart';

class CharacterScreen extends StatelessWidget {
  final PixelAdventure game = PixelAdventure();

  CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Your Character'),
            // Add character selection logic here
            ElevatedButton(
              child: Text('Play'),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => GameWidget(
                    game: kDebugMode ? PixelAdventure() : game,
                    overlayBuilderMap: {
                      'PauseMenu': (BuildContext context, PixelAdventure game) {
                        return MenuOverlay(
                          // Resume game
                          onResume: () {
                            game.overlays.remove('PauseMenu');
                            game.resumeEngine();
                          },
                          // Go to character selection screen
                          onGoToCharacterScreen: () {
                            game.overlays.remove('PauseMenu');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CharacterScreen()),
                            );
                          },
                          // Quit game
                          onQuit: () {
                            game.overlays.remove('PauseMenu');
                            game.overlays.remove('HUD');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InitialScreen()),
                            );
                          },
                        );
                      },
                    },
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
