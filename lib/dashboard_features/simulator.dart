import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_hack/constants.dart';
import 'dart:async';
import 'dart:math';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;

  final Map<String, bool> _systems = {
    'Master Power': false,
    'Life Support': false,
    'Navigation': false,
    'Engine Check': false,
    'Fuel Pumps': false,
  };

  String _mainStatus = "Offline. Engage Master Power.";
  bool _launched = false;

  bool get _allSystemsGo => _systems.values.every((status) => status == true);

  @override
  void initState() {
    super.initState();

    // 🟢 FORCE LANDSCAPE ORIENTATION
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();

    // 🔵 BACK TO NORMAL ORIENTATION WHEN EXITING SCREEN
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  void _toggleSystem(String systemName) {
    if (_launched) return;

    setState(() {
      List<String> systemOrder = _systems.keys.toList();
      int currentIndex = systemOrder.indexOf(systemName);

      if (currentIndex == 0 || _systems[systemOrder[currentIndex - 1]]!) {
        _systems[systemName] = !_systems[systemName]!;
        _updateStatus();
      } else {
        _mainStatus = "ERROR: Activate systems in sequence.";
      }
    });
  }

  void _updateStatus() {
    if (_allSystemsGo) {
      _mainStatus = "All systems nominal. Ready for launch.";
      return;
    }

    for (var entry in _systems.entries) {
      if (!entry.value) {
        _mainStatus = "Awaiting input: ${entry.key}";
        return;
      }
    }
  }

  void _launch() {
    if (!_allSystemsGo || _launched) return;

    setState(() {
      _launched = true;
      _mainStatus = "Launch sequence initiated.";
    });

    int countdown = 3;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() => _mainStatus = "T-${countdown--}...");
      } else {
        timer.cancel();
        setState(() => _mainStatus = "LIFTOFF!");
        _shakeController.repeat();
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _shakeController.reset();
            setState(() => _mainStatus = "Ascent successful. Reaching orbit.");
          }
        });
      }
    });
  }

  void _resetSimulator() {
    setState(() {
      _systems.updateAll((key, value) => false);
      _launched = false;
      _mainStatus = "Offline. Engage Master Power.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDeepSpace,
      appBar: AppBar(title: const Text('COCKPIT SIMULATOR')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = sin(pi * _shakeController.value * 10) * 4;
                  return Transform.translate(
                      offset: Offset(offset, 0), child: child);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      _buildMainDisplay(),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: constraints.maxHeight * 0.75,
                        child: Row(
                          children: [
                            _buildSidePanel(isLeft: true),
                            _buildCenterPanel(),
                            _buildSidePanel(isLeft: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainDisplay() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5),
      border: Border.all(color: kNeonGreen),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      _mainStatus,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: kNeonGreen,
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _buildSidePanel({required bool isLeft}) {
    final keys = isLeft
        ? _systems.keys.take(2).toList()
        : _systems.keys.skip(3).toList();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _buildSystemControl(key)).toList(),
      ),
    );
  }

  Widget _buildCenterPanel() {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSystemControl(_systems.keys.elementAt(2)),
          _buildLaunchControls(),
        ],
      ),
    );
  }

  Widget _buildSystemControl(String systemName) {
    final isActive = _systems[systemName]!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: kTransparentWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kNeonBlue.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            systemName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? kNeonGreen : Colors.red[900],
                  boxShadow: [
                    BoxShadow(
                        color: isActive ? kNeonGreen : Colors.red[900]!,
                        blurRadius: 6)
                  ],
                ),
              ),
              Switch(
                value: isActive,
                onChanged: _launched ? null : (_) => _toggleSystem(systemName),
                activeColor: kNeonGreen,
                activeTrackColor: kNeonGreen.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLaunchControls() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _allSystemsGo && !_launched ? _launch : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            _allSystemsGo && !_launched ? kNeonGreen : Colors.grey[800],
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'LAUNCH',
            style: TextStyle(
                fontSize: 20, letterSpacing: 3, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: _resetSimulator,
          icon: const Icon(Icons.refresh),
          color: kNeonBlue,
          iconSize: 28,
        ),
      ],
    );
  }
}
