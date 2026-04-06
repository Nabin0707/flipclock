import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/core/theme/flip_clock_theme.dart';
import 'package:flutter_clean_architecture/core/utils/time_formatter.dart';
import 'package:flutter_clean_architecture/features/clock/providers/clock_provider.dart';
import 'package:flutter_clean_architecture/widgets/flip_clock_display.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClockScreen extends ConsumerWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockAsync = ref.watch(clockProvider);
    final is24h = ref.watch(clockFormatProvider);
    final flipTheme = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: flipTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Clock',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(clockFormatProvider.notifier).toggle(),
            child: Text(
              is24h ? '24H' : '12H',
              style: TextStyle(
                color: flipTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: clockAsync.when(
        data: (now) {
          final displayHours = is24h
              ? now.hour
              : (now.hour % 12 == 0 ? 12 : now.hour % 12);
          return _ClockBody(
            hours: displayHours,
            minutes: now.minute,
            seconds: now.second,
            dateString: formatDate(now),
            is24h: is24h,
            amPm: now.hour < 12 ? 'AM' : 'PM',
            flipTheme: flipTheme,
          );
        },
        loading: () {
          final now = DateTime.now();
          return _ClockBody(
            hours: now.hour,
            minutes: now.minute,
            seconds: now.second,
            dateString: formatDate(now),
            is24h: is24h,
            amPm: now.hour < 12 ? 'AM' : 'PM',
            flipTheme: flipTheme,
          );
        },
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}

class _ClockBody extends StatelessWidget {
  const _ClockBody({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.dateString,
    required this.is24h,
    required this.amPm,
    required this.flipTheme,
  });

  final int hours;
  final int minutes;
  final int seconds;
  final String dateString;
  final bool is24h;
  final String amPm;
  final FlipClockTheme flipTheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlipClockDisplay(
            hours: hours,
            minutes: minutes,
            seconds: seconds,
            showSeconds: true,
          ),
          const SizedBox(height: 24),
          if (!is24h)
            Text(
              amPm,
              style: TextStyle(
                color: flipTheme.accentColor.withOpacity(0.8),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            dateString,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
