import 'package:flutter/material.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: const Center(
        child: Text('Stopwatch module is being rebuilt step by step.'),
      ),
    );
  }
}
