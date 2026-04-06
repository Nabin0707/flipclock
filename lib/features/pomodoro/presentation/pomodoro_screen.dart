import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/pomodoro/providers/pomodoro_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    state.isWorkPhase ? 'Work Phase' : 'Break Phase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color:
                          state.isWorkPhase ? Colors.deepOrange : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(state.remaining),
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Completed Work Sessions: ${state.completedWorkSessions}'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: state.isRunning ? null : notifier.start,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                      ),
                      OutlinedButton.icon(
                        onPressed: state.isRunning ? notifier.pause : null,
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause'),
                      ),
                      OutlinedButton.icon(
                        onPressed: notifier.skipPhase,
                        icon: const Icon(Icons.skip_next),
                        label: const Text('Skip Phase'),
                      ),
                      TextButton.icon(
                        onPressed: notifier.reset,
                        icon: const Icon(Icons.restore),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Durations',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text('Work: ${state.workDuration.inMinutes} min'),
                  Slider(
                    value: state.workDuration.inMinutes.toDouble().clamp(1, 90),
                    min: 1,
                    max: 90,
                    divisions: 89,
                    onChanged: state.isRunning
                        ? null
                        : (value) => notifier.setWorkMinutes(value.round()),
                  ),
                  const SizedBox(height: 8),
                  Text('Break: ${state.breakDuration.inMinutes} min'),
                  Slider(
                    value:
                        state.breakDuration.inMinutes.toDouble().clamp(1, 30),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    onChanged: state.isRunning
                        ? null
                        : (value) => notifier.setBreakMinutes(value.round()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  final hours = duration.inHours;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
