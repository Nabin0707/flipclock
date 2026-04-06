import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/app_colors.dart';

// TODO: Adjust text styles to match your design system
/// App text styles following Material Design 3 typography
/// Provides consistent text styling across the application
class AppTextStyles {
  AppTextStyles._();

  // Font family - can be customized with custom fonts
  static const String _fontFamily = 'SF Pro Display'; // Default system font

  // ============================================================================
  // DISPLAY STYLES - Largest text
  // ============================================================================

  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle displayMedium(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle displaySmall(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  // ============================================================================
  // HEADLINE STYLES
  // ============================================================================

  static TextStyle headlineLarge(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle headlineMedium(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle headlineSmall(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  // ============================================================================
  // TITLE STYLES
  // ============================================================================

  static TextStyle titleLarge(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle titleMedium(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle titleSmall(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  // ============================================================================
  // BODY STYLES - Most common text
  // ============================================================================

  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: color ??
          (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      fontFamily: _fontFamily,
    );
  }

  // ============================================================================
  // LABEL STYLES - Buttons, tabs, etc.
  // ============================================================================

  static TextStyle labelLarge(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle labelMedium(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.33,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
      fontFamily: _fontFamily,
    );
  }

  static TextStyle labelSmall(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: color ??
          (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      fontFamily: _fontFamily,
    );
  }

  // ============================================================================
  // CUSTOM STYLES
  // ============================================================================

  /// Button text style
  static TextStyle button(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.75,
      color: color ??
          (isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary),
      fontFamily: _fontFamily,
    );
  }

  /// Caption text style
  static TextStyle caption(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: color ??
          (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      fontFamily: _fontFamily,
    );
  }

  /// Overline text style
  static TextStyle overline(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.5,
      height: 1.6,
      color: color ??
          (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
      fontFamily: _fontFamily,
    );
  }
}
