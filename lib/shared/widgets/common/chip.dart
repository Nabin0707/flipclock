import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add animation for chip selection states
/// Customizable chip widget for selections, filters, and tags
class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? avatar;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.avatar,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = isSelected
        ? (selectedColor ?? theme.colorScheme.primaryContainer)
        : (backgroundColor ?? theme.colorScheme.surfaceVariant);
    final effectiveTextColor = isSelected
        ? theme.colorScheme.onPrimaryContainer
        : (textColor ?? theme.colorScheme.onSurfaceVariant);

    return Material(
      color: effectiveBgColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                SizedBox(width: 8.w),
              ] else if (icon != null) ...[
                Icon(icon,
                    size: ResponsiveSpacing.iconXs * 1.125,
                    color: effectiveTextColor),
                SizedBox(width: 6.w),
              ],
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: effectiveTextColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (onDelete != null) ...[
                SizedBox(width: 4.r),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: Icon(
                      Icons.close,
                      size: ResponsiveSpacing.iconXs,
                      color: effectiveTextColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Filter chip with selected state
class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  const FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      icon: isSelected ? Icons.check : icon,
      isSelected: isSelected,
      onTap: () => onSelected(!isSelected),
    );
  }
}

/// Choice chip for single selection
class ChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const ChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      icon: icon,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}

/// Input chip with delete functionality
class InputChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final Widget? avatar;

  const InputChip({
    super.key,
    required this.label,
    this.onDelete,
    this.onTap,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      avatar: avatar,
      onTap: onTap,
      onDelete: onDelete,
    );
  }
}

/// Chip group for multiple selections
class ChipGroup extends StatelessWidget {
  final List<String> labels;
  final List<String> selectedLabels;
  final ValueChanged<List<String>> onSelectionChanged;
  final bool multiSelect;
  final Axis direction;
  final double spacing;
  final double runSpacing;

  const ChipGroup({
    super.key,
    required this.labels,
    required this.selectedLabels,
    required this.onSelectionChanged,
    this.multiSelect = true,
    this.direction = Axis.horizontal,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      spacing: spacing,
      runSpacing: runSpacing,
      children: labels.map((label) {
        final isSelected = selectedLabels.contains(label);
        return FilterChip(
          label: label,
          isSelected: isSelected,
          onSelected: (selected) {
            List<String> newSelection = List.from(selectedLabels);
            if (multiSelect) {
              if (selected) {
                newSelection.add(label);
              } else {
                newSelection.remove(label);
              }
            } else {
              newSelection = selected ? [label] : [];
            }
            onSelectionChanged(newSelection);
          },
        );
      }).toList(),
    );
  }
}
