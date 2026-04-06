import 'package:flutter/material.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: const Center(
        child: Text('Pomodoro module is being rebuilt step by step.'),
      ),
    );
  }
}
