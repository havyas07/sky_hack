import 'package:flutter/material.dart';
import 'package:sky_hack/constants.dart';
import 'dart:async';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  // Using a map to hold the state of all systems
  final Map<String, bool> _systems = {
    'Master Power': false,
    'Life Support': false,
    'Navigation': false,
    'Engine Check': false,
    'Fuel Pumps': false,
  };

  String _mainStatus = "Offline. Engage Master Power.";
  bool _launched = false;

  // Check if all systems are go for launch
  bool get _allSystemsGo {
    return _systems.values.every((status) => status == true);
  }

  void _toggleSystem(String systemName) {
    if (_launched) return;

    setState(() {
      // Allow toggling only in order
      List<String> systemOrder = _systems.keys.toList();
      int currentIndex = systemOrder.indexOf(systemName);

      // Allow turning on the first system, or any system if the previous one is on
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

    // Find the next offline system
    for (var entry in _systems.entries) {
      if (!entry.value) {
        _mainStatus = "Awaiting input: ${entry.key}";
        return;
      }
    }
  }

  void _launch() {
    setState(() {
      _launched = true;
      _mainStatus = "LIFTOFF! We have a liftoff!";
    });
  }

  void _resetSimulator() {
    setState(() {
      _systems.updateAll((key, value) => false);
      _launched = false;
      _updateStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDeepSpace,
      appBar: AppBar(
        title: const Text('COCKPIT SIMULATOR'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMainDisplay(),
            const SizedBox(height: 24),
            _buildControlGrid(),
            const SizedBox(height: 24),
            _buildLaunchControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
  }

  Widget _buildControlGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.0, // FIX: Made taller to prevent overflow
      children: _systems.keys.map((systemName) {
        return _buildSwitchControl(
          label: systemName,
          value: _systems[systemName]!,
          onChanged: (value) => _toggleSystem(systemName),
        );
      }).toList(),
    );
  }

  Widget _buildSwitchControl(
      {required String label, required bool value, required Function(bool) onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: kTransparentWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kNeonBlue.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible( // FIX: Allows text to wrap
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Switch(
            value: value,
            onChanged: _launched ? null : onChanged,
            activeColor: kNeonGreen,
            activeTrackColor: kNeonGreen.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
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
            backgroundColor: _allSystemsGo ? kNeonGreen : Colors.grey[800],
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: _allSystemsGo
                  ? const BorderSide(color: kNeonGreen, width: 2)
                  : BorderSide.none,
            ),
          ),
          child: const Text(
            'LAUNCH',
            style: TextStyle(fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _resetSimulator,
          icon: const Icon(Icons.refresh, size: 20),
          label: const Text('Reset Simulator'),
          style: TextButton.styleFrom(foregroundColor: kNeonBlue),
        ),
      ],
    );
  }
}
