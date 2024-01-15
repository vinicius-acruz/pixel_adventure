import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/menu_button.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/initial_screen.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final PixelAdventure game = PixelAdventure(characterType: 'Mask Dude');
  final PageController _pageController = PageController();

  final Map<String, String> characterNames = {
    'assets/images/gif_players/mask_dude.gif': 'Mask Dude',
    'assets/images/gif_players/ninja_frog.gif': 'Ninja Frog',
    'assets/images/gif_players/pink_man.gif': 'Pink Man',
    'assets/images/gif_players/virtual_guy.gif': 'Virtual Guy',
  };

  int _selectedCharacterIndex = 0;

  String getSelectedCharacterName() {
    final characterPaths = characterNames.keys.toList();
    return characterNames[characterPaths[_selectedCharacterIndex]] ?? 'Unknown';
  }

  // create a onpressed function to start the game
  void onTap() {
    final selectedCharacterName = getSelectedCharacterName();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => GameWidget(
        game: kDebugMode
            ? PixelAdventure(characterType: selectedCharacterName)
            : game,
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
                  MaterialPageRoute(builder: (context) => CharacterScreen()),
                );
              },
              // Quit game
              onQuit: () {
                game.overlays.remove('PauseMenu');
                game.overlays.remove('HUD');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InitialScreen()),
                );
              },
            );
          },
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final characterPaths = characterNames.keys.toList();
    final isLastCharacter =
        _selectedCharacterIndex == characterPaths.length - 1;
    final isFirstCharacter = _selectedCharacterIndex == 0;

    return Scaffold(
      body: Center(
        child: Container(
          // container only in the screen safe area
          constraints: BoxConstraints(),
          width: MediaQuery.of(context).size.width * 0.8,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Your Character', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              Container(
                height: 180,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150, // Set the width
                      height: 200, // Set the height
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: characterPaths.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedCharacterIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: FittedBox(
                              fit: BoxFit.contain, // Set the BoxFit
                              child: Image.asset(characterPaths[index]),
                            ),
                          );
                        },
                      ),
                    ),
                    if (!isFirstCharacter) // Only show if not the first character
                      Positioned(
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    if (!isLastCharacter) // Only show if not the last character
                      Positioned(
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Character: ${getSelectedCharacterName()}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              IndividualButton(onTap: onTap, label: 'Play'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
