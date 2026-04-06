import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/widgets/digit_pair.dart';
import 'package:flutter_clean_architecture/widgets/separator_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlipClockDisplay extends ConsumerWidget {
  const FlipClockDisplay({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
    this.showSeconds = true,
    this.showMilliseconds = false,
    this.milliseconds = 0,
    this.cardScale = 1.0,
  });

  final int hours;
  final int minutes;
  final int seconds;
  final bool showSeconds;
  final bool showMilliseconds;
  final int milliseconds;
  final double cardScale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(settingsProvider);
    final cardHeight = 80.0 * cardScale;
    final cardWidth = 60.0 * cardScale;
    final fontSize = 52.0 * cardScale;
    final sepFontSize = 48.0 * cardScale;
    final flipDuration = Duration(milliseconds: theme.flipDurationMs.toInt());

    final clockRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DigitPair(
          value: hours,
          cardHeight: cardHeight,
          cardWidth: cardWidth,
          cardColor: theme.cardColor,
          textColor: theme.cardTextColor,
          borderRadius: theme.cardBorderRadius,
          fontSize: fontSize,
          fontFamily: theme.fontFamily,
          flipDuration: flipDuration,
          glowEnabled: theme.glowEnabled,
          glowColor: theme.glowColor,
        ),
        SeparatorWidget(
          color: theme.separatorColor,
          fontSize: sepFontSize,
          pulseEnabled: true,
        ),
        DigitPair(
          value: minutes,
          cardHeight: cardHeight,
          cardWidth: cardWidth,
          cardColor: theme.cardColor,
          textColor: theme.cardTextColor,
          borderRadius: theme.cardBorderRadius,
          fontSize: fontSize,
          fontFamily: theme.fontFamily,
          flipDuration: flipDuration,
          glowEnabled: theme.glowEnabled,
          glowColor: theme.glowColor,
        ),
        if (showSeconds) ...[
          SeparatorWidget(
            color: theme.separatorColor,
            fontSize: sepFontSize,
            pulseEnabled: true,
          ),
          DigitPair(
            value: seconds,
            cardHeight: cardHeight,
            cardWidth: cardWidth,
            cardColor: theme.cardColor,
            textColor: theme.cardTextColor,
            borderRadius: theme.cardBorderRadius,
            fontSize: fontSize,
            fontFamily: theme.fontFamily,
            flipDuration: flipDuration,
            glowEnabled: theme.glowEnabled,
            glowColor: theme.glowColor,
          ),
        ],
        if (showMilliseconds) ...[
          const SizedBox(width: 8),
          _MsDisplay(
            ms: milliseconds ~/ 10,
            cardHeight: cardHeight * 0.65,
            cardWidth: cardWidth * 0.65,
            cardColor: theme.cardColor,
            textColor: theme.cardTextColor,
            borderRadius: theme.cardBorderRadius,
            fontSize: fontSize * 0.6,
            fontFamily: theme.fontFamily,
            flipDuration: const Duration(milliseconds: 80),
          ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: clockRow,
          ),
        );
      },
    );
  }
}

class _MsDisplay extends StatelessWidget {
  const _MsDisplay({
    required this.ms,
    required this.cardHeight,
    required this.cardWidth,
    required this.cardColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontSize,
    required this.fontFamily,
    required this.flipDuration,
  });

  final int ms;
  final double cardHeight;
  final double cardWidth;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final String fontFamily;
  final Duration flipDuration;

  @override
  Widget build(BuildContext context) {
    return DigitPair(
      value: ms.clamp(0, 99),
      cardHeight: cardHeight,
      cardWidth: cardWidth,
      cardColor: cardColor,
      textColor: textColor,
      borderRadius: borderRadius,
      fontSize: fontSize,
      fontFamily: fontFamily,
      flipDuration: flipDuration,
    );
  }
}
