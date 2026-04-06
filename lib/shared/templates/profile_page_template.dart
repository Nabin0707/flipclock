import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/avatar.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/cards/custom_card.dart';

// TODO: Add profile editing and image upload functionality
/// Template for user profile pages
/// Shows user information, stats, and actions
class ProfilePageTemplate extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? imageUrl;
  final List<ProfileStat>? stats;
  final List<ProfileAction>? actions;
  final List<ProfileInfoItem>? infoItems;
  final VoidCallback? onEditProfile;
  final VoidCallback? onImageTap;
  final Widget? customHeader;
  final List<Widget>? customSections;

  const ProfilePageTemplate({
    super.key,
    required this.name,
    this.subtitle,
    this.imageUrl,
    this.stats,
    this.actions,
    this.infoItems,
    this.onEditProfile,
    this.onImageTap,
    this.customHeader,
    this.customSections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                children: [
                  // Profile Avatar
                  GestureDetector(
                    onTap: onImageTap,
                    child: AppAvatar(
                      imageUrl: imageUrl,
                      name: name,
                      size: 100,
                      showBorder: true,
                      borderColor: theme.colorScheme.surface,
                      borderWidth: 4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name and Subtitle
                  Text(
                    name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Edit Profile Button
                  if (onEditProfile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: PrimaryButton(
                        text: 'Edit Profile',
                        icon: Icons.edit,
                        onPressed: onEditProfile,
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Stats
                  if (stats != null && stats!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildStats(context, stats!),
                    ),
                  const SizedBox(height: 16),
                  // Custom Header
                  if (customHeader != null) customHeader!,
                  // Quick Actions
                  if (actions != null && actions!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildActions(context, actions!),
                    ),
                  // Info Items
                  if (infoItems != null && infoItems!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildInfoItems(context, infoItems!),
                    ),
                  // Custom Sections
                  if (customSections != null) ...customSections!,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, List<ProfileStat> stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.map((stat) => _StatItem(stat: stat)).toList(),
    );
  }

  Widget _buildActions(BuildContext context, List<ProfileAction> actions) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((action) => _ActionButton(action: action)).toList(),
    );
  }

  Widget _buildInfoItems(BuildContext context, List<ProfileInfoItem> items) {
    return CustomCard(
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _InfoItem(item: item),
              if (index < items.length - 1) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final ProfileStat stat;

  const _StatItem({required this.stat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          stat.value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final ProfileAction action;

  const _ActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: action.onTap,
      icon: Icon(action.icon),
      label: Text(action.label),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final ProfileInfoItem item;

  const _InfoItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: item.icon != null
          ? Icon(item.icon, color: theme.colorScheme.primary)
          : null,
      title: Text(item.label),
      subtitle: item.value != null ? Text(item.value!) : null,
      trailing: item.trailing ?? const Icon(Icons.chevron_right),
      onTap: item.onTap,
    );
  }
}

class ProfileStat {
  final String label;
  final String value;

  ProfileStat({required this.label, required this.value});
}

class ProfileAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  ProfileAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class ProfileInfoItem {
  final String label;
  final String? value;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  ProfileInfoItem({
    required this.label,
    this.value,
    this.icon,
    this.trailing,
    this.onTap,
  });
}
