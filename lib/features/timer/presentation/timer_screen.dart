import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/timer/providers/timer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerProvider);
    final notifier = ref.read(timerProvider.notifier);
    final minutes = state.total.inMinutes.toDouble().clamp(1.0, 180.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _formatDuration(state.remaining),
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (state.isCompleted)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Timer complete',
                        style: TextStyle(color: Colors.green),
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
                    'Set Duration',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Slider(
                    value: minutes,
                    min: 1,
                    max: 180,
                    divisions: 179,
                    label: '${minutes.round()} min',
                    onChanged: state.isRunning
                        ? null
                        : (value) {
                            notifier
                                .setDuration(Duration(minutes: value.round()));
                          },
                  ),
                  Text('Selected: ${minutes.round()} minutes'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _PresetButton(
                          label: '5m', minutes: 5, enabled: !state.isRunning),
                      _PresetButton(
                          label: '15m', minutes: 15, enabled: !state.isRunning),
                      _PresetButton(
                          label: '25m', minutes: 25, enabled: !state.isRunning),
                      _PresetButton(
                          label: '45m', minutes: 45, enabled: !state.isRunning),
                    ],
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

class _PresetButton extends ConsumerWidget {
  const _PresetButton({
    required this.label,
    required this.minutes,
    required this.enabled,
  });

  final String label;
  final int minutes;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: enabled
          ? () {
              ref.read(timerProvider.notifier).setDuration(
                    Duration(minutes: minutes),
                  );
            }
          : null,
      child: Text(label),
    );
  }
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
