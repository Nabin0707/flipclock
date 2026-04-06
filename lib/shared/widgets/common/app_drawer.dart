import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App drawer with header and menu items
/// Customizable navigation drawer for the app
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    this.header,
    required this.items,
    this.footer,
  });

  final Widget? header;
  final List<DrawerItem> items;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          // Header
          if (header != null) header! else _buildDefaultHeader(context),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item.isDivider) {
                  return Divider(
                    height: 16.h,
                    thickness: 1,
                    indent: 16.w,
                    endIndent: 16.w,
                  );
                }
                return _buildDrawerItem(context, item);
              },
            ),
          ),

          // Footer
          if (footer != null) ...[
            Divider(height: 1.h),
            footer!,
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: theme.colorScheme.onPrimary,
            child: Icon(
              Icons.person,
              size: 32.sp,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'App Name',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'user@example.com',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, DrawerItem item) {
    final theme = Theme.of(context);
    final isSelected = item.isSelected ?? false;

    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        item.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: item.trailing ??
          (item.badge != null
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    item.badge!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null),
      selected: isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      onTap: item.onTap,
    );
  }
}

/// Drawer item data class
class DrawerItem {
  const DrawerItem({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.badge,
    this.onTap,
    this.isSelected,
    this.isDivider = false,
  });

  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? badge;
  final VoidCallback? onTap;
  final bool? isSelected;
  final bool isDivider;

  /// Create a divider item
  factory DrawerItem.divider() {
    return const DrawerItem(
      title: '',
      isDivider: true,
    );
  }
}

/// Simple drawer with user profile
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userAvatarUrl,
    required this.menuItems,
    this.onProfileTap,
  });

  final String userName;
  final String userEmail;
  final String? userAvatarUrl;
  final List<DrawerItem> menuItems;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppDrawer(
      header: InkWell(
        onTap: onProfileTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 24.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundImage:
                    userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null,
                backgroundColor: theme.colorScheme.onPrimary,
                child: userAvatarUrl == null
                    ? Icon(
                        Icons.person,
                        size: 32.sp,
                        color: theme.colorScheme.primary,
                      )
                    : null,
              ),
              SizedBox(height: 12.h),
              Text(
                userName,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                userEmail,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
      items: menuItems,
    );
  }
}
