import 'dart:convert';
import 'package:flutter/material.dart';

enum BackgroundStyle { solid, gradient, texture }

class FlipClockTheme {
  final Color cardColor;
  final Color cardTextColor;
  final Color backgroundColor;
  final Color separatorColor;
  final Color accentColor;
  final double cardBorderRadius;
  final double flipDurationMs;
  final bool glowEnabled;
  final Color glowColor;
  final String fontFamily;
  final BackgroundStyle backgroundStyle;

  const FlipClockTheme({
    required this.cardColor,
    required this.cardTextColor,
    required this.backgroundColor,
    required this.separatorColor,
    required this.accentColor,
    required this.cardBorderRadius,
    required this.flipDurationMs,
    required this.glowEnabled,
    required this.glowColor,
    required this.fontFamily,
    required this.backgroundStyle,
  });

  static FlipClockTheme get defaultDark => const FlipClockTheme(
        cardColor: Color(0xFF1C1D22),
        cardTextColor: Color(0xFFF2F2F2),
        backgroundColor: Color(0xFF070808),
        separatorColor: Color(0xFFE8A020),
        accentColor: Color(0xFFE8A020),
        cardBorderRadius: 22.0,
        flipDurationMs: 450.0,
        glowEnabled: false,
        glowColor: Color(0xFFE8A020),
        fontFamily: 'Roboto',
        backgroundStyle: BackgroundStyle.solid,
      );

  static FlipClockTheme get defaultLight => const FlipClockTheme(
        cardColor: Color(0xFF1565C0),
        cardTextColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFFF5F5F5),
        separatorColor: Color(0xFF1565C0),
        accentColor: Color(0xFF1565C0),
        cardBorderRadius: 8.0,
        flipDurationMs: 450.0,
        glowEnabled: false,
        glowColor: Color(0xFF1565C0),
        fontFamily: 'RobotoMono',
        backgroundStyle: BackgroundStyle.solid,
      );

  FlipClockTheme copyWith({
    Color? cardColor,
    Color? cardTextColor,
    Color? backgroundColor,
    Color? separatorColor,
    Color? accentColor,
    double? cardBorderRadius,
    double? flipDurationMs,
    bool? glowEnabled,
    Color? glowColor,
    String? fontFamily,
    BackgroundStyle? backgroundStyle,
  }) {
    return FlipClockTheme(
      cardColor: cardColor ?? this.cardColor,
      cardTextColor: cardTextColor ?? this.cardTextColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      separatorColor: separatorColor ?? this.separatorColor,
      accentColor: accentColor ?? this.accentColor,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      flipDurationMs: flipDurationMs ?? this.flipDurationMs,
      glowEnabled: glowEnabled ?? this.glowEnabled,
      glowColor: glowColor ?? this.glowColor,
      fontFamily: fontFamily ?? this.fontFamily,
      backgroundStyle: backgroundStyle ?? this.backgroundStyle,
    );
  }

  Map<String, dynamic> toJson() => {
        'cardColor': cardColor.value,
        'cardTextColor': cardTextColor.value,
        'backgroundColor': backgroundColor.value,
        'separatorColor': separatorColor.value,
        'accentColor': accentColor.value,
        'cardBorderRadius': cardBorderRadius,
        'flipDurationMs': flipDurationMs,
        'glowEnabled': glowEnabled,
        'glowColor': glowColor.value,
        'fontFamily': fontFamily,
        'backgroundStyle': backgroundStyle.index,
      };

  factory FlipClockTheme.fromJson(Map<String, dynamic> json) => FlipClockTheme(
        cardColor: Color(json['cardColor'] as int),
        cardTextColor: Color(json['cardTextColor'] as int),
        backgroundColor: Color(json['backgroundColor'] as int),
        separatorColor: Color(json['separatorColor'] as int),
        accentColor: Color(json['accentColor'] as int),
        cardBorderRadius: (json['cardBorderRadius'] as num).toDouble(),
        flipDurationMs: (json['flipDurationMs'] as num).toDouble(),
        glowEnabled: json['glowEnabled'] as bool,
        glowColor: Color(json['glowColor'] as int),
        fontFamily: json['fontFamily'] as String,
        backgroundStyle: BackgroundStyle.values[json['backgroundStyle'] as int],
      );

  String toJsonString() => jsonEncode(toJson());

  factory FlipClockTheme.fromJsonString(String jsonString) =>
      FlipClockTheme.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
