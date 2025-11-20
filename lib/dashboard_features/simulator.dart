import 'package:flutter/material.dart';
import 'dart:async';

class SimpleRocketSimulation extends StatefulWidget {
  const SimpleRocketSimulation({super.key});

  @override
  State<SimpleRocketSimulation> createState() => _SimpleRocketSimulationState();
}

class _SimpleRocketSimulationState extends State<SimpleRocketSimulation> {
  double rocketY = 0.5; // starting vertical position
  bool engineOn = false;
  Timer? timer;

  void startEngine() {
    engineOn = true;

    timer ??= Timer.periodic(const Duration(milliseconds: 30), (t) {
      setState(() {
        if (engineOn) {
          rocketY -= 0.01; // rocket goes UP
        } else {
          rocketY += 0.008; // gravity pulls DOWN
        }

        // boundaries
        if (rocketY < -1.0) rocketY = -1.0;
        if (rocketY > 0.8) rocketY = 0.8;
      });
    });
  }

  void stopEngine() {
    engineOn = false;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Rocket
          AnimatedAlign(
            alignment: Alignment(0, rocketY),
            duration: const Duration(milliseconds: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.rocket_launch,
                    size: 80,
                    color: engineOn ? Colors.orange : Colors.white),
                if (engineOn)
                  Container(
                    width: 16,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.yellow, Colors.red],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              ],
            ),
          ),

          // Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: startEngine,
                onLongPress: stopEngine,
                child: const Text(
                  "THRUST",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
