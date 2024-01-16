import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:pixel_adventure/components/menu_button.dart';
import 'package:pixel_adventure/screens/character_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  InitialScreenState createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen>
    with TickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4048),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            image: Image.asset('assets/images/HUD/sparkle_2.png'),
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
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.90,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/HUD/pixel 1.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: IndividualButton(
                        label: 'START',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CharacterScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
