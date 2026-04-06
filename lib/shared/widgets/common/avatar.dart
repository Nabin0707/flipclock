import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Customizable avatar widget with cached network image support
/// TODO: Add more avatar styles and animations
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final bool showOnlineIndicator;
  final bool isOnline;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
    this.showOnlineIndicator = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor =
        backgroundColor ?? theme.colorScheme.primaryContainer;
    final effectiveTextColor =
        textColor ?? theme.colorScheme.onPrimaryContainer;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: effectiveBgColor,
        border: showBorder
            ? Border.all(
                color: borderColor ?? theme.colorScheme.primary,
                width: borderWidth,
              )
            : null,
      ),
      child: imageUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (context, url) => Container(
                  color: effectiveBgColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.r,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: effectiveBgColor,
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: effectiveTextColor,
                  ),
                ),
              ),
            )
          : Center(
              child: icon != null
                  ? Icon(icon, size: size * 0.5, color: effectiveTextColor)
                  : Text(
                      _getInitials(name),
                      style: TextStyle(
                        color: effectiveTextColor,
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
    );

    if (showOnlineIndicator) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? Colors.green : Colors.grey,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2.r,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: avatar,
      );
    }

    return avatar;
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

/// Avatar group showing multiple avatars
class AvatarGroup extends StatelessWidget {
  final List<String> imageUrls;
  final List<String>? names;
  final double size;
  final int maxVisible;
  final VoidCallback? onTap;

  const AvatarGroup({
    super.key,
    required this.imageUrls,
    this.names,
    this.size = 40,
    this.maxVisible = 3,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleCount =
        imageUrls.length > maxVisible ? maxVisible : imageUrls.length;
    final remainingCount = imageUrls.length - maxVisible;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        height: size,
        width: size + (visibleCount - 1) * (size * 0.7),
        child: Stack(
          children: [
            ...List.generate(
              visibleCount,
              (index) => Positioned(
                left: index * (size * 0.7),
                child: AppAvatar(
                  imageUrl: imageUrls[index],
                  name: names?[index],
                  size: size,
                  showBorder: true,
                  borderColor: theme.colorScheme.surface,
                ),
              ),
            ),
            if (remainingCount > 0)
              Positioned(
                left: visibleCount * (size * 0.7),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.secondaryContainer,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2.r,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+$remainingCount',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontSize: size * 0.35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
