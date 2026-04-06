import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/core/utils/time_formatter.dart';
import 'package:flutter_clean_architecture/features/stopwatch/providers/stopwatch_provider.dart';
import 'package:flutter_clean_architecture/widgets/flip_clock_display.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopwatchScreen extends ConsumerWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sw = ref.watch(stopwatchProvider);
    final notifier = ref.read(stopwatchProvider.notifier);
    final flipTheme = ref.watch(settingsProvider);
    final elapsed = sw.elapsed;

    return Scaffold(
      backgroundColor: flipTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Stopwatch',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          FlipClockDisplay(
            hours: elapsed.inHours,
            minutes: elapsed.inMinutes.remainder(60),
            seconds: elapsed.inSeconds.remainder(60),
            showMilliseconds: true,
            milliseconds: elapsed.inMilliseconds.remainder(1000),
          ),
          const SizedBox(height: 32),
          _ControlButtons(
            isRunning: sw.isRunning,
            hasStarted: sw.elapsed > Duration.zero,
            onStart: notifier.start,
            onPause: notifier.pause,
            onReset: notifier.reset,
            onLap: notifier.lap,
            accentColor: flipTheme.accentColor,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _LapList(
              laps: sw.laps,
              bestIndex: sw.bestLapIndex,
              worstIndex: sw.worstLapIndex,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButtons extends StatelessWidget {
  const _ControlButtons({
    required this.isRunning,
    required this.hasStarted,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onLap,
    required this.accentColor,
  });

  final bool isRunning;
  final bool hasStarted;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onLap;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleButton(
          icon: isRunning ? Icons.pause : Icons.play_arrow,
          color: accentColor,
          onTap: isRunning ? onPause : onStart,
          size: 64,
        ),
        const SizedBox(width: 24),
        _CircleButton(
          icon: Icons.flag,
          color: Colors.white24,
          onTap: isRunning ? onLap : null,
          size: 48,
        ),
        const SizedBox(width: 24),
        _CircleButton(
          icon: Icons.refresh,
          color: Colors.white24,
          onTap: hasStarted ? onReset : null,
          size: 48,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.3 : 1.0,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: size * 0.5),
        ),
      ),
    );
  }
}

class _LapList extends StatelessWidget {
  const _LapList({
    required this.laps,
    required this.bestIndex,
    required this.worstIndex,
  });

  final List<LapEntry> laps;
  final int bestIndex;
  final int worstIndex;

  @override
  Widget build(BuildContext context) {
    if (laps.isEmpty) {
      return const Center(
        child: Text(
          'No laps recorded',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: laps.length,
      itemBuilder: (context, index) {
        final lap = laps[laps.length - 1 - index];
        final isBest = (laps.length - 1 - index) == bestIndex;
        final isWorst = (laps.length - 1 - index) == worstIndex;
        Color? highlight;
        if (isBest) highlight = Colors.green.withOpacity(0.2);
        if (isWorst) highlight = Colors.red.withOpacity(0.2);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: highlight ?? Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isBest
                  ? Colors.green.withOpacity(0.5)
                  : isWorst
                      ? Colors.red.withOpacity(0.5)
                      : Colors.white12,
            ),
          ),
          child: Row(
            children: [
              Text(
                'Lap ${lap.lapNumber}',
                style: TextStyle(
                  color: isBest
                      ? Colors.green
                      : isWorst
                          ? Colors.red
                          : Colors.white60,
                  fontSize: 14,
                ),
              ),
              if (isBest)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.star, color: Colors.green, size: 14),
                ),
              if (isWorst)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.red,
                    size: 14,
                  ),
                ),
              const Spacer(),
              Text(
                _fmt(lap.lapTime),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 16),
              Text(
                _fmt(lap.totalTime),
                style: const TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    final ms = d.inMilliseconds.remainder(1000) ~/ 10;
    return '${padTwo(m)}:${padTwo(s)}.${padTwo(ms)}';
  }
}
