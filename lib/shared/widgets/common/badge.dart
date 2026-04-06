import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: Add animation support for badge appearance
/// Badge widget for showing notifications, counts, or status
class AppBadge extends StatelessWidget {
  final String? label;
  final int? count;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;
  final bool showZero;
  final int? maxCount;
  final Widget? child;
  final BadgePosition position;

  const AppBadge({
    super.key,
    this.label,
    this.count,
    this.backgroundColor,
    this.textColor,
    this.size,
    this.showZero = false,
    this.maxCount = 99,
    this.child,
    this.position = BadgePosition.topRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.colorScheme.error;
    final effectiveTextColor = textColor ?? theme.colorScheme.onError;

    // Don't show badge if count is 0 and showZero is false
    if (count != null && count! <= 0 && !showZero) {
      return child ?? const SizedBox.shrink();
    }

    final badgeContent =
        _buildBadgeContent(theme, effectiveBgColor, effectiveTextColor);

    if (child == null) {
      return badgeContent;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        _buildPositionedBadge(badgeContent),
      ],
    );
  }

  Widget _buildPositionedBadge(Widget badgeContent) {
    switch (position) {
      case BadgePosition.topRight:
        return Positioned(top: -4.r, right: -4.r, child: badgeContent);
      case BadgePosition.topLeft:
        return Positioned(top: -4.r, left: -4.r, child: badgeContent);
      case BadgePosition.bottomRight:
        return Positioned(bottom: -4.r, right: -4.r, child: badgeContent);
      case BadgePosition.bottomLeft:
        return Positioned(bottom: -4.r, left: -4.r, child: badgeContent);
    }
  }

  Widget _buildBadgeContent(ThemeData theme, Color bgColor, Color textColor) {
    String? displayText;
    if (count != null) {
      displayText = count! > maxCount! ? '$maxCount!+' : '$count';
    } else if (label != null) {
      displayText = label;
    }

    final badgeSize = size ??
        (displayText != null && displayText.length > 1 ? 20.0.r : 16.0.r);

    return Container(
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      padding: displayText != null && displayText.length > 1
          ? EdgeInsets.symmetric(horizontal: 6.r, vertical: 2.r)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: bgColor,
        shape: displayText == null || displayText.length == 1
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: displayText != null && displayText.length > 1
            ? BorderRadius.circular(badgeSize / 2)
            : null,
      ),
      child: displayText != null
          ? Center(
              child: Text(
                displayText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontSize: badgeSize * 0.6,
                  fontWeight: FontWeight.bold,
                  height: 1.r,
                ),
              ),
            )
          : null,
    );
  }
}

/// Badge position enum
enum BadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

/// Status badge for showing online/offline/busy states
class StatusBadge extends StatelessWidget {
  StatusBadge({
    super.key,
    required this.status,
    this.label,
    double? size,
  }) : size = (size ?? 12).r;
  final BadgeStatus status;
  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: status.color,
            border: Border.all(
              color: theme.colorScheme.surface,
              width: 2.r,
            ),
          ),
        ),
        if (label != null) ...[
          SizedBox(width: 6.r),
          Text(
            label!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

enum BadgeStatus {
  online(Colors.green),
  offline(Colors.grey),
  busy(Colors.red),
  away(Colors.orange);

  final Color color;
  const BadgeStatus(this.color);
}
