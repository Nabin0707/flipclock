import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/theme/app_colors.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add custom snackbar animations and positions
/// App snackbars utility class for showing various snackbar types
class AppSnackbars {
  AppSnackbars._();

  /// Show info snackbar
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _showSnackbar(
      context: context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: AppColors.getStatusColor(StatusType.info, isDark),
      duration: duration,
      action: action,
    );
  }

  /// Show success snackbar
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _showSnackbar(
      context: context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: AppColors.getStatusColor(StatusType.success, isDark),
      duration: duration,
      action: action,
    );
  }

  /// Show error snackbar
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _showSnackbar(
      context: context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: AppColors.getStatusColor(StatusType.error, isDark),
      duration: duration,
      action: action,
    );
  }

  /// Show warning snackbar
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _showSnackbar(
      context: context,
      message: message,
      icon: Icons.warning_amber_outlined,
      backgroundColor: AppColors.getStatusColor(StatusType.warning, isDark),
      duration: duration,
      action: action,
    );
  }

  /// Show custom snackbar
  static void showCustom({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration,
      action: action,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.inverseSurface;
    final effectiveTextColor = textColor ?? theme.colorScheme.onInverseSurface;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: effectiveTextColor,
                size: ResponsiveSpacing.iconSm,
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontSize: ResponsiveSpacing.iconXs * 0.875,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: effectiveBackgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  /// Hide current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// Snackbar action button
class AppSnackbarAction extends SnackBarAction {
  AppSnackbarAction({
    required super.label,
    required super.onPressed,
    Color? textColor,
  }) : super(
          textColor: textColor ?? Colors.white,
        );
}
