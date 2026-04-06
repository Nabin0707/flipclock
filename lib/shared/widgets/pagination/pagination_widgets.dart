import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Customize pagination widget styling and behavior
/// Widget to show load more indicator at the bottom of lists
class LoadMoreIndicator extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final VoidCallback? onRetry;
  final String? errorMessage;

  const LoadMoreIndicator({
    super.key,
    this.isLoading = false,
    this.message,
    this.onRetry,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (errorMessage != null) {
      return Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 8.h),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }

    if (!isLoading) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24.r,
            height: 24.r,
            child: CircularProgressIndicator(strokeWidth: 2.r),
          ),
          if (message != null) ...[
            SizedBox(height: 8.h),
            Text(
              message!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget to show "No more items" indicator
class NoMoreItemsIndicator extends StatelessWidget {
  final String message;
  final IconData? icon;

  const NoMoreItemsIndicator({
    super.key,
    this.message = 'No more items to load',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: ResponsiveSpacing.iconLg,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Pagination info widget showing current page/total items
class PaginationInfo extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  const PaginationInfo({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startItem = (currentPage - 1) * itemsPerPage + 1;
    final endItem = (currentPage * itemsPerPage).clamp(0, totalItems);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: ResponsiveSpacing.iconXs,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 8.w),
          Text(
            'Showing $startItem-$endItem of $totalItems',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4.r),
          Text(
            '(Page $currentPage of $totalPages)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Page number buttons for pagination
class PageNumberButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int maxVisiblePages;

  const PageNumberButtons({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxVisiblePages = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate visible page range
    int startPage = (currentPage - maxVisiblePages ~/ 2).clamp(1, totalPages);
    int endPage = (startPage + maxVisiblePages - 1).clamp(1, totalPages);

    if (endPage - startPage < maxVisiblePages - 1) {
      startPage = (endPage - maxVisiblePages + 1).clamp(1, totalPages);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        IconButton(
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous',
        ),

        // First page
        if (startPage > 1) ...[
          _buildPageButton(context, theme, 1),
          if (startPage > 2)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text('...', style: theme.textTheme.bodyMedium),
            ),
        ],

        // Page numbers
        ...List.generate(
          endPage - startPage + 1,
          (index) {
            final page = startPage + index;
            return _buildPageButton(context, theme, page);
          },
        ),

        // Last page
        if (endPage < totalPages) ...[
          if (endPage < totalPages - 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text('...', style: theme.textTheme.bodyMedium),
            ),
          _buildPageButton(context, theme, totalPages),
        ],

        // Next button
        IconButton(
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next',
        ),
      ],
    );
  }

  Widget _buildPageButton(BuildContext context, ThemeData theme, int page) {
    final isActive = page == currentPage;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: InkWell(
        onTap: () => onPageChanged(page),
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: 40.r,
          height: 40.h,
          decoration: BoxDecoration(
            color: isActive ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$page',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
