import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/widgets/flip_card.dart';

class DigitPair extends StatelessWidget {
  const DigitPair({
    super.key,
    required this.value,
    required this.cardHeight,
    required this.cardWidth,
    required this.cardColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontSize,
    required this.fontFamily,
    required this.flipDuration,
    this.glowEnabled = false,
    this.glowColor = Colors.amber,
  });

  final int value;
  final double cardHeight;
  final double cardWidth;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final String fontFamily;
  final Duration flipDuration;
  final bool glowEnabled;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    final tens = (value ~/ 10).clamp(0, 9);
    final units = (value % 10).clamp(0, 9);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlipCard(
          digit: tens,
          height: cardHeight,
          width: cardWidth,
          cardColor: cardColor,
          textColor: textColor,
          borderRadius: borderRadius,
          fontSize: fontSize,
          fontFamily: fontFamily,
          flipDuration: flipDuration,
          glowEnabled: glowEnabled,
          glowColor: glowColor,
        ),
        const SizedBox(width: 4),
        FlipCard(
          digit: units,
          height: cardHeight,
          width: cardWidth,
          cardColor: cardColor,
          textColor: textColor,
          borderRadius: borderRadius,
          fontSize: fontSize,
          fontFamily: fontFamily,
          flipDuration: flipDuration,
          glowEnabled: glowEnabled,
          glowColor: glowColor,
        ),
      ],
    );
  }
}
