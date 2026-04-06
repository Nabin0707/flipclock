import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/stopwatch/providers/stopwatch_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopwatchScreen extends ConsumerWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stopwatchProvider);
    final notifier = ref.read(stopwatchProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _formatDuration(state.elapsed),
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
                        onPressed: state.isRunning ? notifier.lap : null,
                        icon: const Icon(Icons.flag),
                        label: const Text('Lap'),
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
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Laps',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (state.laps.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No laps yet.'),
                    )
                  else
                    ...state.laps.asMap().entries.map((entry) {
                      final idx = entry.key + 1;
                      final lap = entry.value;
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Lap $idx'),
                        trailing: Text(_formatDuration(lap)),
                      );
                    }),
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
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  final centiseconds = (duration.inMilliseconds % 1000) ~/ 10;

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${centiseconds.toString().padLeft(2, '0')}';
}
