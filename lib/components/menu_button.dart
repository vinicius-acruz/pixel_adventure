import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class MenuButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  final VoidCallback showMenuOverlay;
  final VoidCallback hideMenuOverlay;

  MenuButton(this.showMenuOverlay, this.hideMenuOverlay);

  final double margin = 20;
  final double buttonSize = 30;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/MenuButton.png'));
    position = Vector2(
      margin,
      margin,
    );
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Show menu overlay
    showMenuOverlay(); // Show the menu overlay
    print('Menu button tapped');
    super.onTapDown(event);
  }
}

class MenuOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onGoToCharacterScreen;
  final VoidCallback onQuit;

  MenuOverlay({
    required this.onResume,
    required this.onGoToCharacterScreen,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // add container image
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('PauseMenu/menu.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: onResume,
            child: const Text('Resume'),
          ),
          ElevatedButton(
            onPressed: onGoToCharacterScreen,
            child: Text('Go to Character Screen'),
          ),
          ElevatedButton(
            onPressed: onQuit,
            child: Text('Quit'),
          ),
        ],
      ),
    );
  }
}
