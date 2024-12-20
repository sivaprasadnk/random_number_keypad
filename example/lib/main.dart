import 'package:flutter/material.dart';
import 'package:random_number_keypad/random_number_keypad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Number Keypad Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RandomPinExample(),
    );
  }
}

class RandomPinExample extends StatelessWidget {
  const RandomPinExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(title: const Text('Random PIN Keyboard')),
      body: Center(
        child: RandomNumberKeypad(
          inputFillColor: Colors.white,
          inputTextStyle:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          doneButtonTextStyle: const TextStyle(color: Colors.deepOrange),
          pinLength: 4,
          inputShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          showInput: true,
          buttonColor: Colors.red,
          buttonTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          onComplete: (pin) {
            print('Entered PIN: $pin');
            // Add PIN validation logic here.
          },
        ),
      ),
    );
  }
}
