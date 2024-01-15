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

  // create a sprite component as a background

//
  @override
  Widget build(BuildContext context) {
    // return the sprite component as a background
    return Container(
      // container taking full space
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        // add a sprite component as a background
        image: const DecorationImage(
          image: AssetImage('assets/images/HUD/menu.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        IndividualButton(onTap: onResume, label: 'Resume'),
        const SizedBox(height: 20),
        IndividualButton(
            onTap: onGoToCharacterScreen, label: 'Go to character screen'),
        const SizedBox(height: 20),
        IndividualButton(onTap: onQuit, label: 'Quit'),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class IndividualButton extends StatelessWidget {
  const IndividualButton({super.key, required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 250,
      decoration: const BoxDecoration(
        // add a sprite component as a background
        image: DecorationImage(
          image: AssetImage('assets/images/HUD/menu_button.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
