import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

// TODO: Add product rating, wishlist, and quick actions
/// Product card widget for e-commerce or catalog display
/// Displays product image, name, price, and optional badge
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String price;
  final String? originalPrice;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final double? width;
  final double? height;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    required this.price,
    this.originalPrice,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: width ?? 180.w,
          height: height ?? 280.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with badge
              Stack(
                children: [
                  Container(
                    height: 160.h,
                    width: double.infinity,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.r,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                                Icons.image,
                                size: ResponsiveSpacing.iconXxl),
                          )
                        : Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image,
                                  size: ResponsiveSpacing.iconXxl);
                            },
                          ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor ?? theme.colorScheme.error,
                          borderRadius:
                              BorderRadius.circular(ResponsiveSpacing.radiusXs),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveFontSizes.xs.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (onFavorite != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: onFavorite,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: ResponsiveSpacing.all(6),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: ResponsiveSpacing.iconSm,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Product details
              Expanded(
                child: Padding(
                  padding: ResponsiveSpacing.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            price,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (originalPrice != null) ...[
                            SizedBox(width: 8.r),
                            Text(
                              originalPrice!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal product card for list views
class HorizontalProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String price;
  final String? originalPrice;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const HorizontalProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    required this.price,
    this.originalPrice,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: ResponsiveSpacing.all(12),
          child: Row(
            children: [
              // Image
              Stack(
                children: [
                  Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius:
                          BorderRadius.circular(ResponsiveSpacing.radiusSm),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ResponsiveSpacing.radiusSm),
                      child: imageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.r,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image),
                            )
                          : Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image);
                              },
                            ),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor ?? theme.colorScheme.error,
                          borderRadius:
                              BorderRadius.circular(ResponsiveSpacing.radiusXs),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveSpacing.iconXs * 0.5625.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          price,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (originalPrice != null) ...[
                          SizedBox(width: 8.r),
                          Text(
                            originalPrice!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
