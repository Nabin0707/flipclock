import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/theme/app_colors.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add custom dialog animations and transitions
/// App dialogs utility class for showing various dialog types
class AppDialogs {
  AppDialogs._();

  /// Show info dialog
  static Future<bool?> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        icon: Icons.info_outline,
        iconColor: AppColors.getStatusColor(
            StatusType.info, Theme.of(context).brightness == Brightness.dark),
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  /// Show success dialog
  static Future<bool?> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        icon: Icons.check_circle_outline,
        iconColor: AppColors.getStatusColor(StatusType.success,
            Theme.of(context).brightness == Brightness.dark),
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  /// Show error dialog
  static Future<bool?> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        icon: Icons.error_outline,
        iconColor: AppColors.getStatusColor(
            StatusType.error, Theme.of(context).brightness == Brightness.dark),
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  /// Show warning dialog
  static Future<bool?> showWarningDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        icon: Icons.warning_amber_outlined,
        iconColor: AppColors.getStatusColor(StatusType.warning,
            Theme.of(context).brightness == Brightness.dark),
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        icon: Icons.help_outline,
        iconColor: Theme.of(context).colorScheme.primary,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  /// Show delete confirmation dialog
  static Future<bool?> showDeleteConfirmDialog({
    required BuildContext context,
    String title = 'Delete',
    String message = 'Are you sure you want to delete this item?',
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        icon: Icons.delete_outline,
        iconColor: AppColors.getStatusColor(
            StatusType.error, Theme.of(context).brightness == Brightness.dark),
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        isDangerous: true,
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _LoadingDialog(message: message),
    );
  }

  /// Show custom dialog
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }
}

class _AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const _AppDialog({
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    required this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCancel = cancelText != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Column(
        children: [
          if (icon != null)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: (iconColor ?? theme.colorScheme.primary)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? theme.colorScheme.primary,
                size: ResponsiveSpacing.iconLg,
              ),
            ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (hasCancel)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                onCancel?.call();
              },
              child: Text(cancelText!),
            ),
          ),
        if (hasCancel) SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            style: isDangerous
                ? ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: Colors.white,
                  )
                : null,
            child: Text(confirmText),
          ),
        ),
      ],
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final String message;

  const _LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
