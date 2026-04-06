import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/flip_clock_theme.dart';
import 'package:flutter_clean_architecture/widgets/digit_pair.dart';

class FullscreenFlipClockFace extends StatelessWidget {
  const FullscreenFlipClockFace({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.dateString,
    required this.flipTheme,
    this.secondaryLabel,
  });

  final int hours;
  final int minutes;
  final int seconds;
  final String dateString;
  final FlipClockTheme flipTheme;
  final String? secondaryLabel;

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
                        if (secondaryLabel != null &&
                            secondaryLabel!.isNotEmpty)
                          Text(
                            secondaryLabel!.toUpperCase(),
                            style: TextStyle(
                              color:
                                  flipTheme.accentColor.withValues(alpha: 0.8),
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
                          child: _FullscreenClockPanelCard(
                            value: hours,
                            panelHeight: panelHeight,
                            flipTheme: flipTheme,
                            panelColor: panelColor,
                            periodText: null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _FullscreenClockPanelCard(
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
                _FullscreenClockPanelCard(
                  value: hours,
                  panelHeight: panelHeight,
                  flipTheme: flipTheme,
                  panelColor: panelColor,
                  periodText: null,
                ),
                const SizedBox(height: 16),
                _FullscreenClockPanelCard(
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

class _FullscreenClockPanelCard extends StatelessWidget {
  const _FullscreenClockPanelCard({
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
          final availableHeight =
              (constraints.maxHeight - 24).clamp(140.0, 380.0);
          final maxDigitWidth =
              ((constraints.maxWidth - 44) / 2).clamp(100.0, 340.0);
          final digitWidth =
              (constraints.maxWidth * 0.42).clamp(84.0, maxDigitWidth);
          final fontSize = (availableHeight * 0.50).clamp(42.0, 168.0);

          return Stack(
            children: [
              Center(
                child: DigitPair(
                  value: value,
                  cardHeight: availableHeight,
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
                      cardHeight: availableHeight * 0.28,
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
