import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add horizontal timeline and custom indicators
/// Timeline widget for showing chronological events
class AppTimeline extends StatelessWidget {
  final List<TimelineItem> items;
  final Color? lineColor;
  final double lineWidth;
  final double indicatorSize;

  const AppTimeline({
    super.key,
    required this.items,
    this.lineColor,
    this.lineWidth = 2,
    this.indicatorSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLineColor =
        lineColor ?? theme.colorScheme.outline.withValues(alpha: 0.3);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              Column(
                children: [
                  _TimelineIndicator(
                    item: item,
                    size: indicatorSize,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: lineWidth,
                        color: effectiveLineColor,
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16.w),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                  child: item.content,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  final TimelineItem item;
  final double size;

  const _TimelineIndicator({
    required this.item,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (item.customIndicator != null) {
      return item.customIndicator!;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: item.indicatorColor ?? theme.colorScheme.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 3.r,
        ),
      ),
      child: item.icon != null
          ? Icon(
              item.icon,
              size: size * 0.5,
              color: Colors.white,
            )
          : null,
    );
  }
}

class TimelineItem {
  final Widget content;
  final IconData? icon;
  final Color? indicatorColor;
  final Widget? customIndicator;

  TimelineItem({
    required this.content,
    this.icon,
    this.indicatorColor,
    this.customIndicator,
  });
}

/// Simple stepper widget for multi-step processes
class AppStepper extends StatelessWidget {
  final List<StepItem> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? theme.colorScheme.outline.withValues(alpha: 0.3);

    return Column(
      children: [
        // Step indicators
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector line
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              return Expanded(
                child: Container(
                  height: 2.h,
                  color: isCompleted
                      ? effectiveActiveColor
                      : effectiveInactiveColor,
                ),
              );
            } else {
              // Step circle
              final stepIndex = index ~/ 2;
              final isActive = stepIndex == currentStep;
              final isCompleted = stepIndex < currentStep;

              return GestureDetector(
                onTap: onStepTapped != null
                    ? () => onStepTapped!(stepIndex)
                    : null,
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? effectiveActiveColor
                        : effectiveInactiveColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2.r,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check,
                            size: ResponsiveSpacing.iconXs, color: Colors.white)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveSpacing.iconXs * 0.875,
                            ),
                          ),
                  ),
                ),
              );
            }
          }),
        ),
        SizedBox(height: 16.h),
        // Step labels
        Row(
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            final isActive = index == currentStep;

            return Expanded(
              child: Text(
                step.title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive
                      ? effectiveActiveColor
                      : theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ),
        SizedBox(height: 24.h),
        // Current step content
        steps[currentStep].content,
      ],
    );
  }
}

class StepItem {
  final String title;
  final Widget content;

  StepItem({
    required this.title,
    required this.content,
  });
}
