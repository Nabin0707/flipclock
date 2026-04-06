import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/core/theme/flip_clock_theme.dart';
import 'package:flutter_clean_architecture/core/utils/time_formatter.dart';
import 'package:flutter_clean_architecture/features/clock/providers/clock_provider.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:flutter_clean_architecture/widgets/flip_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
            onPressed: () => ref.read(clockFormatProvider.notifier).toggle(),
            child: Text(
              is24h ? '24H' : '12H',
              style: TextStyle(
                color: flipTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white54),
            onPressed: () => context.push(Routes.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: clockAsync.when(
        data: (now) {
          final displayHours =
              is24h ? now.hour : (now.hour % 12 == 0 ? 12 : now.hour % 12);
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
    final hourText = is24h ? hours.toString().padLeft(2, '0') : '$hours';
    final minuteText = minutes.toString().padLeft(2, '0');
    final secondText = seconds.toString().padLeft(2, '0');

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = (constraints.maxHeight * 0.30).clamp(180.0, 300.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            child: Column(
              children: [
                _TimePanelCard(
                  valueText: hourText,
                  cardHeight: cardHeight,
                  flipTheme: flipTheme,
                  periodText: is24h ? null : amPm,
                ),
                const SizedBox(height: 16),
                _TimePanelCard(
                  valueText: minuteText,
                  cardHeight: cardHeight,
                  flipTheme: flipTheme,
                  secondsText: secondText,
                ),
                const SizedBox(height: 24),
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
        },
      ),
    );
  }
}

class _TimePanelCard extends StatelessWidget {
  const _TimePanelCard({
    required this.valueText,
    required this.cardHeight,
    required this.flipTheme,
    this.periodText,
    this.secondsText,
  });

  final String valueText;
  final double cardHeight;
  final FlipClockTheme flipTheme;
  final String? periodText;
  final String? secondsText;

  @override
  Widget build(BuildContext context) {
    final digitChars = valueText.split('');

    return Container(
      width: double.infinity,
      height: cardHeight,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: flipTheme.cardColor,
        borderRadius: BorderRadius.circular(flipTheme.cardBorderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gap = 10.0;
          final digitCount = digitChars.length;
          final totalGap = gap * (digitCount - 1);
          final digitWidth = ((constraints.maxWidth - totalGap) / digitCount)
              .clamp(72.0, 180.0);
          final digitHeight = (constraints.maxHeight - 20).clamp(140.0, 240.0);
          final fontSize = (digitHeight * 0.58).clamp(48.0, 140.0);

          return Stack(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < digitChars.length; i++) ...[
                      FlipCard(
                        digit: int.parse(digitChars[i]),
                        height: digitHeight,
                        width: digitWidth,
                        cardColor: flipTheme.cardColor,
                        textColor: flipTheme.cardTextColor,
                        borderRadius: flipTheme.cardBorderRadius,
                        fontSize: fontSize,
                        fontFamily: flipTheme.fontFamily,
                        flipDuration: Duration(
                            milliseconds: flipTheme.flipDurationMs.toInt()),
                        glowEnabled: false,
                        glowColor: flipTheme.glowColor,
                      ),
                      if (i != digitChars.length - 1) SizedBox(width: gap),
                    ],
                  ],
                ),
              ),
              if (periodText != null)
                Positioned(
                  left: 6,
                  bottom: 0,
                  child: Text(
                    periodText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 36,
                    ),
                  ),
                ),
              if (secondsText != null)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Row(
                    children: secondsText!.split('').map((ch) {
                      return Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          ch,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
