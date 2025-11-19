import 'package:flutter/material.dart';
import 'package:sky_hack/constants.dart';
import 'dart:math';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDeepSpace,
      appBar: AppBar(
        title: const Text('ASTRONAUT FITNESS'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressChart(),
            const SizedBox(height: 32),
            _buildSectionTitle('DAILY PROTOCOLS'),
            const SizedBox(height: 16),
            _buildProtocolItem(
                Icons.directions_run, 'Zero-G Treadmill', '30 min'),
            _buildProtocolItem(
                Icons.fitness_center, 'Resistance Training', '45 min'),
            _buildProtocolItem(
                Icons.accessibility_new, 'Flexibility Drills', '15 min'),
            const SizedBox(height: 32),
            _buildSectionTitle('WORKOUT STATS'),
            const SizedBox(height: 16),
            _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: CustomPaint(
          painter: _ProgressChartPainter(),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '75%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: kAquaGlow,
                  ),
                ),
                Text(
                  'Weekly Goal',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: kNeonGreen,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildProtocolItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: kTransparentWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kNeonBlue.withOpacity(0.3))),
      child: Row(
        children: [
          Icon(icon, color: kNeonBlue, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5, // Gave cards more height to prevent overflow
      children: [
        _StatCard(label: 'Calories Burned', value: '350 kcal'),
        _StatCard(label: 'Heart Rate', value: '120 bpm'),
        _StatCard(label: 'Workout Duration', value: '90 min'),
        _StatCard(label: 'Steps Taken', value: '5,000'),
      ],
    );
  }
}

class _ProgressChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Background circle
    paint.color = kTransparentWhite;
    canvas.drawCircle(center, radius, paint);

    // Progress arc
    paint.color = kAquaGlow;
    final progress = 0.75; // 75%
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // Themed container to match the dashboard
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kNeonBlue.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: kNeonGreen,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
