import 'package:flutter_clean_architecture/core/theme/flip_clock_theme.dart';
import 'package:flutter_clean_architecture/core/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kFlipClockThemeKey = 'flip_clock_theme';
const _kClockFormatKey = 'clock_format_24h';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, FlipClockTheme>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});

class SettingsNotifier extends StateNotifier<FlipClockTheme> {
  SettingsNotifier(this._prefs) : super(FlipClockTheme.defaultDark) {
    _load();
  }

  final SharedPreferences _prefs;

  void _load() {
    final json = _prefs.getString(_kFlipClockThemeKey);
    if (json != null) {
      try {
        state = FlipClockTheme.fromJsonString(json);
      } catch (_) {
        state = FlipClockTheme.defaultDark;
      }
    }
  }

  Future<void> _save() async {
    try {
      await _prefs.setString(_kFlipClockThemeKey, state.toJsonString());
    } catch (_) {
      // Silently ignore persistence failures; state is still updated in memory.
    }
  }

  void updateCardColor(Color color) {
    state = state.copyWith(cardColor: color);
    _save();
  }

  void updateCardTextColor(Color color) {
    state = state.copyWith(cardTextColor: color);
    _save();
  }

  void updateBackgroundColor(Color color) {
    state = state.copyWith(backgroundColor: color);
    _save();
  }

  void updateAccentColor(Color color) {
    state = state.copyWith(accentColor: color, separatorColor: color);
    _save();
  }

  void setGlowEnabled(bool enabled) {
    state = state.copyWith(glowEnabled: enabled);
    _save();
  }

  void setGlowColor(Color color) {
    state = state.copyWith(glowColor: color);
    _save();
  }

  void setFlipDuration(double ms) {
    state = state.copyWith(flipDurationMs: ms);
    _save();
  }

  void setFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
    _save();
  }

  void setCardBorderRadius(double radius) {
    state = state.copyWith(cardBorderRadius: radius);
    _save();
  }

  void setBackgroundStyle(BackgroundStyle style) {
    state = state.copyWith(backgroundStyle: style);
    _save();
  }

  void resetToDefaults() {
    state = FlipClockTheme.defaultDark;
    _save();
  }

  void applyPreset(FlipClockTheme theme) {
    state = theme;
    _save();
  }
}

final clockFormatProvider =
    StateNotifierProvider<ClockFormatNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ClockFormatNotifier(prefs);
});

class ClockFormatNotifier extends StateNotifier<bool> {
  ClockFormatNotifier(this._prefs) : super(true) {
    _load();
  }

  final SharedPreferences _prefs;

  void _load() {
    state = _prefs.getBool(_kClockFormatKey) ?? true;
  }

  void toggle() {
    state = !state;
    _prefs.setBool(_kClockFormatKey, state);
  }

  void set24h(bool value) {
    state = value;
    _prefs.setBool(_kClockFormatKey, state);
  }
}
