import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/features/pomodoro/providers/pomodoro_provider.dart';
import 'package:flutter_clean_architecture/widgets/flip_clock_display.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);
    final flipTheme = ref.watch(settingsProvider);

    final phaseColor = _phaseColor(state.phase);
    final phaseName = _phaseName(state.phase);
    final r = state.remaining;

    return Scaffold(
      backgroundColor: Color.lerp(flipTheme.backgroundColor, phaseColor, 0.1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pomodoro',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Session ${state.sessionCount + 1}',
              style: TextStyle(
                color: phaseColor.withOpacity(0.7),
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              phaseName.toUpperCase(),
              style: TextStyle(
                color: phaseColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 340,
                  height: 340,
                  child: CustomPaint(
                    painter: _ArcPainter(
                      progress: state.progress,
                      color: phaseColor,
                    ),
                  ),
                ),
                FlipClockDisplay(
                  hours: r.inHours,
                  minutes: r.inMinutes.remainder(60),
                  seconds: r.inSeconds.remainder(60),
                  showSeconds: true,
                ),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleBtn(
                  icon: state.isRunning ? Icons.pause : Icons.play_arrow,
                  color: phaseColor,
                  onTap: state.isRunning ? notifier.pause : notifier.start,
                  size: 64,
                ),
                const SizedBox(width: 24),
                _CircleBtn(
                  icon: Icons.skip_next,
                  color: Colors.white38,
                  onTap: notifier.skip,
                  size: 48,
                ),
                const SizedBox(width: 24),
                _CircleBtn(
                  icon: Icons.refresh,
                  color: Colors.white38,
                  onTap: notifier.reset,
                  size: 48,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _phaseColor(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return const Color(0xFFE8A020);
      case PomodoroPhase.shortBreak:
        return const Color(0xFF4CAF50);
      case PomodoroPhase.longBreak:
        return const Color(0xFF2196F3);
    }
  }

  String _phaseName(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return 'Work';
      case PomodoroPhase.shortBreak:
        return 'Short Break';
      case PomodoroPhase.longBreak:
        return 'Long Break';
    }
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final bgPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({
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
    );
  }
}
