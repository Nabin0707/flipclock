import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add custom empty state illustrations or animations
/// Empty state widget for displaying when there's no data
class EmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData? icon;
  final Widget? illustration;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsets? padding;

  const EmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    this.illustration,
    this.actionText,
    this.onAction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or icon
            if (illustration != null)
              illustration!
            else if (icon != null)
              Icon(
                icon,
                size: ResponsiveSpacing.iconXxl * 1.67,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
              )
            else
              Icon(
                Icons.inbox_outlined,
                size: ResponsiveSpacing.iconXxl * 1.67,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
              ),
            SizedBox(height: 24.h),
            // Message
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
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
            // Action button
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(Icons.add, size: ResponsiveSpacing.iconSm),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty search results widget
class EmptySearchResults extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClear;

  const EmptySearchResults({
    super.key,
    required this.searchQuery,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      message: 'No results found',
      subtitle: 'No results for "$searchQuery".\nTry different keywords.',
      actionText: onClear != null ? 'Clear Search' : null,
      onAction: onClear,
    );
  }
}

/// Empty list widget
class EmptyList extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyList({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.list_alt,
      message: title,
      subtitle: subtitle,
      actionText: actionText,
      onAction: onAction,
    );
  }
}

/// No data widget
class NoData extends StatelessWidget {
  final String? message;

  const NoData({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.cloud_off_outlined,
      message: message ?? 'No data available',
      subtitle: 'Please check back later.',
    );
  }
}

/// No internet connection widget
class NoInternetConnection extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetConnection({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.wifi_off,
      message: 'No Internet Connection',
      subtitle: 'Please check your connection and try again.',
      actionText: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
    );
  }
}
