import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Add custom theme modes if needed (e.g., system, light, dark, custom)
/// Theme mode provider that manages the current theme mode
/// Persists theme preference using SharedPreferences
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';

  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  /// Load saved theme mode from local storage
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_themeModeKey);

      if (savedThemeMode != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedThemeMode,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e) {
      // If error loading, keep system default
      state = ThemeMode.system;
    }
  }

  /// Save theme mode to local storage
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } catch (e) {
      // Handle error silently
    }
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    _saveThemeMode(newMode);
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    state = mode;
    _saveThemeMode(mode);
  }

  /// Set light theme
  void setLightTheme() {
    state = ThemeMode.light;
    _saveThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  void setDarkTheme() {
    state = ThemeMode.dark;
    _saveThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  void setSystemTheme() {
    state = ThemeMode.system;
    _saveThemeMode(ThemeMode.system);
  }

  /// Check if current theme is dark
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => state == ThemeMode.light;

  /// Check if using system theme
  bool get isSystemMode => state == ThemeMode.system;
}

/// Provider to check if current brightness is dark
/// Takes into account system brightness when theme mode is system
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);

  if (themeMode == ThemeMode.system) {
    // TODO: Implement system brightness detection if needed
    // For now, default to light when system
    return false;
  }

  return themeMode == ThemeMode.dark;
});
