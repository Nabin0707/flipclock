import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add half-star rating support and custom star shapes
/// Rating widget for displaying and interacting with ratings
class AppRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final ValueChanged<double>? onRatingChanged;
  final bool allowHalfRating;
  final double spacing;
  final bool readOnly;

  const AppRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.onRatingChanged,
    this.allowHalfRating = false,
    this.spacing = 4,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? Colors.amber;
    final effectiveInactiveColor =
        inactiveColor ?? theme.colorScheme.outline.withValues(alpha: 0.3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1.0;
        final isFilled = rating >= starValue;
        final isHalfFilled =
            allowHalfRating && rating >= starValue - 0.5 && rating < starValue;

        return Padding(
          padding: EdgeInsets.only(right: index < maxRating - 1 ? spacing : 0),
          child: GestureDetector(
            onTap: readOnly || onRatingChanged == null
                ? null
                : () => onRatingChanged!(starValue),
            child: Icon(
              isHalfFilled
                  ? Icons.star_half
                  : isFilled
                      ? Icons.star
                      : Icons.star_border,
              size: size,
              color: isFilled || isHalfFilled
                  ? effectiveActiveColor
                  : effectiveInactiveColor,
            ),
          ),
        );
      }),
    );
  }
}

/// Rating display with count
class RatingWithCount extends StatelessWidget {
  final double rating;
  final int? count;
  final int maxRating;
  final double size;
  final Color? activeColor;

  const RatingWithCount({
    super.key,
    required this.rating,
    this.count,
    this.maxRating = 5,
    this.size = 20,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppRating(
          rating: rating,
          maxRating: maxRating,
          size: size,
          activeColor: activeColor,
          readOnly: true,
        ),
        SizedBox(width: 6.w),
        Text(
          rating.toStringAsFixed(1),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (count != null) ...[
          Text(
            ' ($count)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Rating bar with percentage breakdown
class RatingBreakdown extends StatelessWidget {
  final Map<int, int> ratings; // {star: count}
  final int totalRatings;
  final Color? activeColor;

  const RatingBreakdown({
    super.key,
    required this.ratings,
    required this.totalRatings,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = activeColor ?? Colors.amber;

    return Column(
      children: List.generate(5, (index) {
        final star = 5 - index;
        final count = ratings[star] ?? 0;
        final percentage = totalRatings > 0 ? count / totalRatings : 0.0;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              Text(
                '$star',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(width: 4.w),
              Icon(Icons.star,
                  size: ResponsiveSpacing.iconXs * 0.875, color: Colors.amber),
              SizedBox(width: 8.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation(effectiveColor),
                    minHeight: 8,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 40.r,
                child: Text(
                  '${(percentage * 100).toInt()}%',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
