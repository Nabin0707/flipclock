import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add more tag variants and animations
/// Tag widget for labels, categories, and status indicators
class AppTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const AppTag({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor =
        backgroundColor ?? theme.colorScheme.secondaryContainer;
    final effectiveTextColor =
        textColor ?? theme.colorScheme.onSecondaryContainer;

    return Material(
      color: effectiveBgColor,
      borderRadius: borderRadius ?? BorderRadius.circular(4.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(4.r),
        child: Container(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize ?? 12, color: effectiveTextColor),
                SizedBox(width: 4.r),
              ],
              Text(
                label,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontSize: fontSize ?? 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status tag with predefined colors
class StatusTag extends StatelessWidget {
  final String label;
  final TagStatus status;
  final IconData? icon;

  const StatusTag({
    super.key,
    required this.label,
    required this.status,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppTag(
      label: label,
      backgroundColor: status.backgroundColor,
      textColor: status.textColor,
      icon: icon,
    );
  }
}

enum TagStatus {
  success(Colors.green, Colors.white),
  warning(Colors.orange, Colors.white),
  error(Colors.red, Colors.white),
  info(Colors.blue, Colors.white),
  pending(Colors.grey, Colors.white);

  final Color backgroundColor;
  final Color textColor;
  const TagStatus(this.backgroundColor, this.textColor);
}

/// Outlined tag variant
class OutlinedTag extends StatelessWidget {
  final String label;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;

  const OutlinedTag({
    super.key,
    required this.label,
    this.borderColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = borderColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: effectiveColor),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: ResponsiveSpacing.iconXs * 0.75,
                color: effectiveTextColor),
            SizedBox(width: 4.r),
          ],
          Text(
            label,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: ResponsiveSpacing.iconXs * 0.75,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
