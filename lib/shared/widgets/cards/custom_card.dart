import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add gesture detection (swipe, long press) if needed
/// Custom card widget with flexible layout options
/// Base card that can be customized for various use cases
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(ResponsiveSpacing.radiusMd);

    return Container(
      margin: margin,
      child: Material(
        color: color,
        elevation: elevation ?? 0,
        borderRadius: effectiveBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: effectiveBorderRadius,
          child: Container(
            padding: padding ?? ResponsiveSpacing.all(16),
            decoration: border != null
                ? BoxDecoration(
                    border: border,
                    borderRadius: effectiveBorderRadius,
                  )
                : null,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Card with header and content sections
class HeaderCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget content;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const HeaderCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.content,
    this.padding,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Padding(
              padding: padding ?? ResponsiveSpacing.all(16),
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: 12.r),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
          Divider(height: 1.h, color: theme.dividerColor),
          // Content
          Padding(
            padding: padding ?? ResponsiveSpacing.all(16),
            child: content,
          ),
          // Actions
          if (actions != null && actions!.isNotEmpty) ...[
            Divider(height: 1.h, color: theme.dividerColor),
            Padding(
              padding: ResponsiveSpacing.all(8),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 4,
                children: actions!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Expandable card with collapsible content
class ExpandableCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final Widget? leading;
  final bool initiallyExpanded;
  final EdgeInsets? padding;

  const ExpandableCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.leading,
    this.initiallyExpanded = false,
    this.padding,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusMd),
            child: Padding(
              padding: widget.padding ?? ResponsiveSpacing.all(16),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    SizedBox(width: 12.r),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            widget.subtitle!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(height: 1.h, color: theme.dividerColor),
            Padding(
              padding: widget.padding ?? ResponsiveSpacing.all(16),
              child: widget.content,
            ),
          ],
        ],
      ),
    );
  }
}
