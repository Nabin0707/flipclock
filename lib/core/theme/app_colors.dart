import 'package:flutter/material.dart';

// TODO: Customize color palette according to your brand identity
/// App color palette for light and dark themes
/// This class contains all colors used throughout the application
class AppColors {
  AppColors._();

  // ============================================================================
  // LIGHT THEME COLORS
  // ============================================================================

  // Primary Colors - Main brand color
  static const Color lightPrimary = Color(0xFF6366F1); // Indigo
  static const Color lightPrimaryVariant = Color(0xFF4F46E5);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  // Secondary Colors - Accent color
  static const Color lightSecondary = Color(0xFF10B981); // Emerald
  static const Color lightSecondaryVariant = Color(0xFF059669);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);

  // Background Colors
  static const Color lightBackground = Color(0xFFF9FAFB); // Gray 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6); // Gray 100

  // Text Colors
  static const Color lightTextPrimary = Color(0xFF111827); // Gray 900
  static const Color lightTextSecondary = Color(0xFF6B7280); // Gray 500
  static const Color lightTextDisabled = Color(0xFF9CA3AF); // Gray 400

  // Border Colors
  static const Color lightBorder = Color(0xFFE5E7EB); // Gray 200
  static const Color lightDivider = Color(0xFFE5E7EB);

  // Status Colors
  static const Color lightSuccess = Color(0xFF10B981); // Emerald 500
  static const Color lightError = Color(0xFFEF4444); // Red 500
  static const Color lightWarning = Color(0xFFF59E0B); // Amber 500
  static const Color lightInfo = Color(0xFF3B82F6); // Blue 500

  // Overlay Colors
  static const Color lightScrim = Color(0x80000000);
  static const Color lightShadow = Color(0x1A000000);

  // ============================================================================
  // DARK THEME COLORS
  // ============================================================================

  // Primary Colors
  static const Color darkPrimary = Color(0xFF818CF8); // Indigo 400
  static const Color darkPrimaryVariant = Color(0xFF6366F1);
  static const Color darkOnPrimary = Color(0xFF1E1B4B); // Indigo 950

  // Secondary Colors
  static const Color darkSecondary = Color(0xFF34D399); // Emerald 400
  static const Color darkSecondaryVariant = Color(0xFF10B981);
  static const Color darkOnSecondary = Color(0xFF022C22); // Emerald 950

  // Background Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700

  // Text Colors
  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextDisabled = Color(0xFF64748B); // Slate 500

  // Border Colors
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkDivider = Color(0xFF334155);

  // Status Colors
  static const Color darkSuccess = Color(0xFF34D399); // Emerald 400
  static const Color darkError = Color(0xFFF87171); // Red 400
  static const Color darkWarning = Color(0xFFFBBF24); // Amber 400
  static const Color darkInfo = Color(0xFF60A5FA); // Blue 400

  // Overlay Colors
  static const Color darkScrim = Color(0x80000000);
  static const Color darkShadow = Color(0x40000000);

  // ============================================================================
  // GRADIENT COLORS
  // ============================================================================

  static const LinearGradient lightPrimaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get status color based on type and theme
  static Color getStatusColor(StatusType type, bool isDark) {
    switch (type) {
      case StatusType.success:
        return isDark ? darkSuccess : lightSuccess;
      case StatusType.error:
        return isDark ? darkError : lightError;
      case StatusType.warning:
        return isDark ? darkWarning : lightWarning;
      case StatusType.info:
        return isDark ? darkInfo : lightInfo;
    }
  }
}

enum StatusType { success, error, warning, info }
