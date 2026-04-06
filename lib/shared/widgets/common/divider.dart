import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add custom divider patterns and styles
/// Customizable divider widgets for visual separation
class AppDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;
  final String? label;

  const AppDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (label != null) {
      return Row(
        children: [
          if (indent != null) SizedBox(width: indent),
          Expanded(
            child: Divider(
              height: height,
              thickness: thickness,
              color: color ?? theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              label!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              height: height,
              thickness: thickness,
              color: color ?? theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          if (endIndent != null) SizedBox(width: endIndent),
        ],
      );
    }

    return Divider(
      height: height,
      thickness: thickness,
      color: color ?? theme.colorScheme.outline.withValues(alpha: 0.2),
      indent: indent,
      endIndent: endIndent,
    );
  }
}

/// Vertical divider widget
class AppVerticalDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const AppVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VerticalDivider(
      width: width,
      thickness: thickness,
      color: color ?? theme.colorScheme.outline.withValues(alpha: 0.2),
      indent: indent,
      endIndent: endIndent,
    );
  }
}

/// Dashed divider for visual variety
class DashedDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final double dashWidth;
  final double dashSpace;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.color,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor =
        color ?? theme.colorScheme.outline.withValues(alpha: 0.2);

    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: effectiveColor,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}

/// Section divider with icon
class SectionDivider extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final double spacing;

  const SectionDivider({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: ResponsiveSpacing.iconSm, color: effectiveColor),
            SizedBox(width: 8.w),
          ],
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Divider(
              color: effectiveColor.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
