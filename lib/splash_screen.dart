import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sky_hack/constants.dart';
import 'package:sky_hack/dashboard.dart';
import 'package:sky_hack/user_login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _flickerController;
  late Animation<double> _flickerAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _flickerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _flickerAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 10),
    ]).animate(
      CurvedAnimation(parent: _flickerController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut,
        ));

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const DashboardScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(seconds: 1),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(seconds: 1),
            ),
          );
        }
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
          children: [
            AnimatedBuilder(
              animation: _flickerAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'NEBULA HORIZON',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: kNeonBlue.withOpacity(0.3),
                        shadows: [
                          Shadow(
                            color: kNeonBlue.withOpacity(
                                0.5 * _flickerAnimation.value),
                            blurRadius: 15,
                          ),
                        ],
                        letterSpacing: 4,
                      ),
                    ),
                    Opacity(
                      opacity: _flickerAnimation.value,
                      child: const Text(
                        'NEBULA HORIZON',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: kNeonBlue,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Initializing Systems for Hackathon Challenge',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 72),
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
                          color:
                          kNeonBlue.withOpacity(0.8 * _pulseAnimation.value),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.satellite_alt_outlined,
                        size: 48,
                        color: kNeonBlue,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Establishing Connection...',
              style: TextStyle(
                fontSize: 14,
                color: kNeonBlue.withOpacity(0.9),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
