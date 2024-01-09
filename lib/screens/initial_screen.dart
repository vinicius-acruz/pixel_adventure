import 'package:flutter/material.dart';
import 'package:pixel_adventure/screens/character_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  InitialScreenState createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('START'),
          onPressed: () {
            // Navigate to character selection screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CharacterScreen()),
            );
          },
        ),
      ),
    );
  }
}
