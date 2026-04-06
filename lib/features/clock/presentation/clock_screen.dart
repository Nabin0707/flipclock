import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/core/theme/flip_clock_theme.dart';
import 'package:flutter_clean_architecture/core/utils/time_formatter.dart';
import 'package:flutter_clean_architecture/features/clock/providers/clock_provider.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:flutter_clean_architecture/widgets/digit_pair.dart';
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
    final panelColor = flipTheme.cardColor.withValues(alpha: 0.96);

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isLandscape) {
            final panelHeight =
                (constraints.maxHeight * 0.78).clamp(170.0, 340.0);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      children: [
                        Text(
                          dateString.toUpperCase(),
                          style: TextStyle(
                            color:
                                flipTheme.cardTextColor.withValues(alpha: 0.55),
                            fontSize: 15,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          is24h ? '' : '$amPm mode',
                          style: TextStyle(
                            color: flipTheme.accentColor.withValues(alpha: 0.8),
                            fontSize: 13,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _TimePanelCard(
                            value: hours,
                            panelHeight: panelHeight,
                            flipTheme: flipTheme,
                            panelColor: panelColor,
                            periodText: is24h ? null : amPm,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _TimePanelCard(
                            value: minutes,
                            panelHeight: panelHeight,
                            flipTheme: flipTheme,
                            panelColor: panelColor,
                            secondsValue: seconds,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final panelHeight =
              (constraints.maxHeight * 0.30).clamp(170.0, 300.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            child: Column(
              children: [
                _TimePanelCard(
                  value: hours,
                  panelHeight: panelHeight,
                  flipTheme: flipTheme,
                  panelColor: panelColor,
                  periodText: is24h ? null : amPm,
                ),
                const SizedBox(height: 16),
                _TimePanelCard(
                  value: minutes,
                  panelHeight: panelHeight,
                  flipTheme: flipTheme,
                  panelColor: panelColor,
                  secondsValue: seconds,
                ),
                const SizedBox(height: 24),
                Text(
                  dateString,
                  style: TextStyle(
                    color: flipTheme.cardTextColor.withValues(alpha: 0.55),
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
    required this.value,
    required this.panelHeight,
    required this.flipTheme,
    required this.panelColor,
    this.periodText,
    this.secondsValue,
  });

  final int value;
  final double panelHeight;
  final FlipClockTheme flipTheme;
  final Color panelColor;
  final String? periodText;
  final int? secondsValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: panelHeight,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(flipTheme.cardBorderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final digitHeight = (constraints.maxHeight - 24).clamp(140.0, 240.0);
          final digitWidth = (constraints.maxWidth * 0.42).clamp(84.0, 160.0);
          final fontSize = (digitHeight * 0.50).clamp(42.0, 108.0);

          return Stack(
            children: [
              Center(
                child: DigitPair(
                  value: value,
                  cardHeight: digitHeight,
                  cardWidth: digitWidth,
                  cardColor: flipTheme.cardColor,
                  textColor: flipTheme.cardTextColor,
                  borderRadius: flipTheme.cardBorderRadius,
                  fontSize: fontSize,
                  fontFamily: flipTheme.fontFamily,
                  flipDuration:
                      Duration(milliseconds: flipTheme.flipDurationMs.toInt()),
                  glowEnabled: flipTheme.glowEnabled,
                  glowColor: flipTheme.glowColor,
                ),
              ),
              if (periodText != null)
                Positioned(
                  left: 6,
                  bottom: 0,
                  child: Text(
                    periodText!,
                    style: TextStyle(
                      color: flipTheme.accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 34,
                    ),
                  ),
                ),
              if (secondsValue != null)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: flipTheme.accentColor.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DigitPair(
                      value: secondsValue!,
                      cardHeight: digitHeight * 0.28,
                      cardWidth: digitWidth * 0.24,
                      cardColor: flipTheme.cardColor.withValues(alpha: 0.9),
                      textColor: flipTheme.cardTextColor,
                      borderRadius:
                          (flipTheme.cardBorderRadius * 0.45).clamp(4.0, 14.0),
                      fontSize: fontSize * 0.28,
                      fontFamily: flipTheme.fontFamily,
                      flipDuration: Duration(
                          milliseconds: flipTheme.flipDurationMs.toInt()),
                      glowEnabled: flipTheme.glowEnabled,
                      glowColor: flipTheme.glowColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
