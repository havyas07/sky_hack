import 'package:flutter/material.dart';
import 'package:sky_hack/constants.dart';

class OrgDashboardScreen extends StatelessWidget {
  const OrgDashboardScreen({super.key});

  // Mock data for demonstration
  final List<Map<String, dynamic>> _astronauts = const [
    {'name': 'Cadet Eva Rostova', 'progress': 0.75, 'status': 'In Simulation'},
    {'name': 'Commander Jax', 'progress': 0.9, 'status': 'Awaiting Mission'},
    {'name': 'Specialist Ken', 'progress': 0.4, 'status': 'Basic Training'},
  ];

  final List<Map<String, dynamic>> _articles = const [
    {
      'title': 'The Physics of Wormholes',
      'description': 'An introduction to theoretical faster-than-light travel.',
      'icon': Icons.public,
    },
    {
      'title': 'Life on Mars',
      'description': 'Analyzing the challenges of colonizing the Red Planet.',
      'icon': Icons.explore,
    },
    {
      'title': 'Building a Dyson Sphere',
      'description': 'Harnessing stellar energy with a megastructure.',
      'icon': Icons.flare,
    },
    {
      'title': 'Dark Matter Explained',
      'description': 'Unveiling the mysteries of the universe\'s missing mass.',
      'icon': Icons.blur_on,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDeepSpace,
      appBar: AppBar(
        title: const Text('ORGANIZATION DASHBOARD'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('ASTRONAUT ROSTER'),
            const SizedBox(height: 16),
            ..._astronauts.map((astro) => _buildAstronautListItem(astro)),
            const SizedBox(height: 40),
            _buildSectionTitle('KNOWLEDGE BASE'),
            const SizedBox(height: 16),
            SizedBox(
              height: 220, // FIX: Increased height to prevent vertical overflow in cards
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  return _buildArticleCard(_articles[index]);
                },
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle('MISSION BRIEFING'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kTransparentWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kNeonBlue.withOpacity(0.3)),
              ),
              child: const Text(
                'Recent scans have detected anomalous energy signatures from the Kepler-186f system. The signatures are consistent with patterns of a Type II civilization, though this is unconfirmed. Astronauts on standby for long-range observation missions. Further intel is classified pending administrative review.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
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

  Widget _buildAstronautListItem(Map<String, dynamic> astronaut) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kTransparentWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kNeonBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            astronaut['name']!,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Training Progress: ${(astronaut['progress']! * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(astronaut['status']!, style: const TextStyle(color: kAquaGlow)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: astronaut['progress']!,
            backgroundColor: kTransparentWhite,
            valueColor: const AlwaysStoppedAnimation<Color>(kAquaGlow),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kTransparentWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kNeonBlue.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: kNeonBlue.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(article['icon'] as IconData, size: 40, color: kAquaGlow),
          const SizedBox(height: 16),
          Text(
            article['title']!,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            article['description']!,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
