import 'package:flutter/material.dart';
// Import the components and constants from the dedicated splash screen file
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nebula Horizon App',
      theme: ThemeData(
        // kDeepSpace is imported from splash_screen.dart
        scaffoldBackgroundColor: kDeepSpace,
        brightness: Brightness.dark,
        // Using a monospaced font for a technical/futuristic feel
        fontFamily: 'monospace',
      ),
      // SplashScreen is the initial entry point
      home: const SplashScreen(),
    );
  }
}