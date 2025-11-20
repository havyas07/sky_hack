import 'package:flutter/material.dart';
import 'package:sky_hack/constants.dart';
import 'package:sky_hack/org_dashboard.dart';

class OrgLoginScreen extends StatefulWidget {
  const OrgLoginScreen({super.key});

  @override
  State<OrgLoginScreen> createState() => _OrgLoginScreenState();
}

class _OrgLoginScreenState extends State<OrgLoginScreen> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_userIdController.text == 'org@1' &&
        _passwordController.text == 'org@1') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrgDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
