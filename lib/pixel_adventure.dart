import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/menu_button.dart';
import 'components/player.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showControls = true; // choose keyboard or joystick
  bool playSounds = true;
  double soundVolume = 1.0;

  List<String> levelNames = ['level-01', 'level-01'];
  int currentLevelIndex = 0;

  final pauseOverlayIdentifier = 'PauseMenu';

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    if (showControls) {
      addJoystick();
      add(JumpButton());
    }
    // Add menu button
    add(MenuButton(showMenuOverlay, hideMenuOverlay));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }

    super.update(dt);
  }

  void showMenuOverlay() {
    overlays.add(pauseOverlayIdentifier); // Show the overlay
    pauseEngine(); // Optionally pause the game
  }

  void hideMenuOverlay() {
    overlays.remove(pauseOverlayIdentifier); // Hide the overlay
    resumeEngine(); // Optionally resume the game
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
          sprite: Sprite(
        images.fromCache('HUD/Knob.png'),
      )),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 32,
        bottom: 32,
      ),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      _loadLevel(); // no more levels - add function later
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      // Set camera settings
      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 360);

      cam.viewfinder.anchor = Anchor.topLeft;
      cam.viewfinder.zoom = 0.5;

      addAll([cam, world]);
    });
  }
}
