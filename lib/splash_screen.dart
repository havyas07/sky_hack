import 'package:flutter/material.dart';
import 'dart:async';

// --- Color Constants ---
// Deep Space Background Color: #0A1426
const Color kDeepSpace = Color(0xFF0A1426);
// Neon Blue/Cyan Color: #00F0FF
const Color kNeonBlue = Color(0xFF00F0FF);

// --- Splash Screen Widget ---

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _flickerController;
  late Animation<double> _flickerAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Flicker Animation (for the main title)
    _flickerController = AnimationController(
      duration: const Duration(seconds: 2), // 2 seconds cycle
      vsync: this,
    )..repeat(reverse: true);

    // Create an intermittent opacity animation for the flicker effect
    _flickerAnimation = TweenSequence<double>([
      // Opacity 1.0 (on) for most of the time
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50.0),
      // Opacity 0.8 (slight flicker down)
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 10.0),
      // Opacity 1.0 (on)
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 30.0),
      // Opacity 0.5 (big flicker down)
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 10.0),
    ]).animate(CurvedAnimation(
      parent: _flickerController,
      curve: Curves.easeInOut,
    ));

    // 2. Pulse Animation (for the loading ring glow/scale)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500), // 1.5 seconds cycle
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // 3. Navigation Timer: Navigate to MainContentScreen after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainContentScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Fade transition for smooth splash screen exit
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _flickerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // App Title with Flicker Effect
            AnimatedBuilder(
              animation: _flickerAnimation,
              builder: (context, child) {
                // Use a Stack to apply the neon glow effect via text shadow
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back layer for neon glow effect
                    Text(
                      'NEBULA HORIZON',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: kNeonBlue.withOpacity(0.3),
                        shadows: [
                          Shadow(
                            color: kNeonBlue.withOpacity(0.5 * _flickerAnimation.value),
                            blurRadius: 15.0,
                          ),
                        ],
                        letterSpacing: 4.0,
                      ),
                    ),
                    // Front text with animation-controlled opacity
                    Opacity(
                      opacity: _flickerAnimation.value,
                      child: Text(
                        'NEBULA HORIZON',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: kNeonBlue,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            // Subtitle
            const Text(
              'Initializing Systems for Hackathon Challenge',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 72),

            // Loading Ring with Pulse Effect
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kNeonBlue, width: 4),
                      boxShadow: [
                        BoxShadow(
                          // Pulsing glow shadow
                          color: kNeonBlue.withOpacity(0.8 * _pulseAnimation.value),
                          blurRadius: 25.0,
                          spreadRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Center(
                      // Wireframe Icon (using a simple satellite)
                      child: Icon(
                        Icons.satellite_alt_outlined,
                        size: 48,
                        color: kNeonBlue.withOpacity(0.9),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Loading Text
            Text(
              'Establishing Connection...',
              style: TextStyle(
                fontSize: 14,
                color: kNeonBlue.withOpacity(0.9),
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Main Content Screen (Destination) ---
// You will replace this with your actual navigation (e.g., a BottomNavBar)

class MainContentScreen extends StatelessWidget {
  const MainContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nebula Horizon Main App',
          style: TextStyle(color: kNeonBlue),
        ),
        backgroundColor: kDeepSpace,
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 80, color: kNeonBlue),
            SizedBox(height: 20),
            Text(
              'Systems Online. Ready for Launch!',
              style: TextStyle(fontSize: 24, color: kNeonBlue),
            ),
            SizedBox(height: 8),
            Text(
              'Start building your main UI modules here.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}