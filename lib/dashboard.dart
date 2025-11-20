
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sky_hack/constants.dart';
import 'package:sky_hack/user_login/login.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:sky_hack/dashboard_features/fitness.dart';
import 'package:sky_hack/dashboard_features/simulator.dart';
import 'package:sky_hack/dashboard_features/quizes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/space_video.mp4');
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: false,
      aspectRatio: 16 / 9,
    );

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? "Astronaut";

    final List<Map<String, dynamic>> items = [
      {'icon': Icons.vrpano_outlined, 'label': 'AR Learning', 'screen': null},
      {
        'icon': Icons.quiz_outlined,
        'label': 'Space Quizzes',
        'screen': const QuizScreen()
      },
      {
        'icon': Icons.fitness_center_outlined,
        'label': 'Astronaut Fitness',
        'screen': const FitnessScreen()
      },
      {'icon': Icons.group_outlined, 'label': 'Community Hub', 'screen': null},
      {
        'icon': Icons.satellite_alt_outlined,
        'label': 'Hazard Detection',
        'screen': null
      },
      {
        'icon': Icons.rocket_launch_outlined,
        'label': 'Rocket Simulator',
        'screen': const SimpleRocketSimulation()
      },
    ];

    return Scaffold(
      backgroundColor: kDeepSpace,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "MISSION CONTROL",
          style: TextStyle(
            color: kNeonBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kNeonBlue),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050A19),
              Color(0xFF0A1426),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 200,
                  child: _chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Chewie(controller: _chewieController!)
                      : const Center(
                          child: CircularProgressIndicator(color: kNeonBlue)),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Welcome Commander",
                style: TextStyle(
                  color: kAquaGlow, // ✔ NEW FUTURISTIC COLOR
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                email,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _holoButton(
                      icon: item['icon'],
                      label: item['label'],
                      onTap: () {
                        if (item['screen'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => item['screen']!),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FUTURISTIC HOLOGRAPHIC BUTTON
  Widget _holoButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: kNeonBlue.withOpacity(0.7),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: kNeonBlue.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 55, color: kAquaGlow), // ✔ REPLACED GREEN
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
