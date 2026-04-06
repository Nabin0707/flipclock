import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add custom error illustrations and reporting options
/// Error widget for displaying error states
class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsets? padding;
  final bool showIcon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.padding,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: ResponsiveSpacing.iconXxl * 1.33,
                  color: theme.colorScheme.error,
                ),
              ),
            SizedBox(height: 24.h),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(Icons.refresh, size: ResponsiveSpacing.iconSm),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? theme.colorScheme.error.withValues(alpha: 0.2)
                      : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: 'Network Error',
      subtitle:
          'Failed to connect to the server.\nPlease check your connection.',
      actionText: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
    );
  }
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? errorCode;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: 'Server Error',
      subtitle: errorCode != null
          ? 'Something went wrong on our end.\nError code: $errorCode'
          : 'Something went wrong on our end.\nPlease try again later.',
      actionText: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
    );
  }
}

/// Something went wrong widget
class SomethingWentWrong extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const SomethingWentWrong({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: message ?? 'Something went wrong',
      subtitle: 'An unexpected error occurred.\nPlease try again.',
      actionText: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
    );
  }
}

/// Inline error message
class InlineErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const InlineErrorMessage({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: ResponsiveSpacing.iconSm,
          ),
          SizedBox(width: 12.r),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(
                Icons.close,
                size: ResponsiveSpacing.iconXs * 1.125,
                color: theme.colorScheme.error,
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
