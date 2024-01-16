import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/menu_button.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/initial_screen.dart';
import 'package:animated_background/animated_background.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>
    with TickerProviderStateMixin {
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
                  MaterialPageRoute(
                      builder: (context) => const CharacterScreen()),
                );
              },
              // Quit game
              onQuit: () {
                game.overlays.remove('PauseMenu');
                game.overlays.remove('HUD');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InitialScreen()),
                );
              },
            );
          },
        },
      ),
    ));
  }

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterPaths = characterNames.keys.toList();
    final isLastCharacter =
        _selectedCharacterIndex == characterPaths.length - 1;
    final isFirstCharacter = _selectedCharacterIndex == 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1B4048),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            image: Image.asset('assets/images/HUD/sparkle_1.png'),
            spawnMinSpeed: 30.0,
            spawnMaxSpeed: 70.0,
            spawnMinRadius: 7.0,
            spawnMaxRadius: 15.0,
            particleCount: 20,
          ),
          paint: Paint()..style = PaintingStyle.fill,
        ),
        vsync: this,
        child: Center(
          child: Container(
            // container only in the screen safe area
            constraints: const BoxConstraints(),
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.transparent,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/HUD/select_character.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.30),
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150, // Set the width
                            height: 120, // Set the height
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                              left: 100,
                              child: IconButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: Image.asset(
                                  'assets/images/Menu/Buttons/Previous.png',
                                  height: 50,
                                  fit: BoxFit.cover,
                                ), // Replace with your left arrow image
                              ),
                            ),
                          if (!isLastCharacter) // Only show if not the last character
                            Positioned(
                              right: 100,
                              child: IconButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: Image.asset(
                                  'assets/images/Menu/Buttons/Next.png',
                                  height: 50,
                                  fit: BoxFit.cover,
                                ), // Replace with your right arrow image
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IndividualButton(
                        animate: false,
                        onTap: () {},
                        label: 'Character: ${getSelectedCharacterName()}'),
                    const SizedBox(
                      height: 10,
                    ),
                    IndividualButton(onTap: onTap, label: 'Play'),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
