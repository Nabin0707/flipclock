import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/widgets/cards/custom_card.dart';

// TODO: Add preferences persistence and dynamic settings
/// Template for settings pages
/// Organize settings into sections with various input types
class SettingsPageTemplate extends StatelessWidget {
  final String title;
  final List<SettingsSection> sections;

  const SettingsPageTemplate({
    super.key,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final section = sections[index];
          return _buildSection(context, section);
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, SettingsSection section) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              section.title!,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        CustomCard(
          child: Column(
            children: section.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildItem(context, item),
                  if (index < section.items.length - 1)
                    const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, SettingsItem item) {
    switch (item.type) {
      case SettingsItemType.toggle:
        return _ToggleSettingItem(item: item);
      case SettingsItemType.navigation:
        return _NavigationSettingItem(item: item);
      case SettingsItemType.selection:
        return _SelectionSettingItem(item: item);
      case SettingsItemType.action:
        return _ActionSettingItem(item: item);
    }
  }
}

class _ToggleSettingItem extends StatelessWidget {
  final SettingsItem item;

  const _ToggleSettingItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: item.icon != null ? Icon(item.icon) : null,
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      value: item.value as bool? ?? false,
      onChanged: (value) => item.onChanged?.call(value),
    );
  }
}

class _NavigationSettingItem extends StatelessWidget {
  final SettingsItem item;

  const _NavigationSettingItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: item.icon != null ? Icon(item.icon) : null,
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: item.trailing ?? const Icon(Icons.chevron_right),
      onTap: item.onTap,
    );
  }
}

class _SelectionSettingItem extends StatelessWidget {
  final SettingsItem item;

  const _SelectionSettingItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: item.icon != null ? Icon(item.icon) : null,
      title: Text(item.title),
      subtitle: item.value != null
          ? Text(
              item.value.toString(),
              style: TextStyle(color: theme.colorScheme.primary),
            )
          : null,
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: item.onTap,
    );
  }
}

class _ActionSettingItem extends StatelessWidget {
  const _ActionSettingItem({required this.item});
  final SettingsItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: item.icon != null
          ? Icon(
              item.icon,
              color: item.isDangerous == true ? theme.colorScheme.error : null,
            )
          : null,
      title: Text(
        item.title,
        style: TextStyle(
          color: item.isDangerous == true ? theme.colorScheme.error : null,
        ),
      ),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: item.trailing,
      onTap: item.onTap,
    );
  }
}

class SettingsSection {
  final String? title;
  final List<SettingsItem> items;

  SettingsSection({
    this.title,
    required this.items,
  });
}

enum SettingsItemType {
  toggle,
  navigation,
  selection,
  action,
}

class SettingsItem {
  final SettingsItemType type;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final dynamic value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ValueChanged<dynamic>? onChanged;
  final bool? isDangerous;

  SettingsItem({
    required this.type,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.trailing,
    this.onTap,
    this.onChanged,
    this.isDangerous,
  });

  factory SettingsItem.toggle({
    required String title,
    String? subtitle,
    IconData? icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SettingsItem(
      type: SettingsItemType.toggle,
      title: title,
      subtitle: subtitle,
      icon: icon,
      value: value,
      onChanged: (dynamic val) => onChanged(val as bool),
    );
  }

  factory SettingsItem.navigation({
    required String title,
    String? subtitle,
    IconData? icon,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return SettingsItem(
      type: SettingsItemType.navigation,
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: trailing,
      onTap: onTap,
    );
  }

  factory SettingsItem.selection({
    required String title,
    required String currentValue,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return SettingsItem(
      type: SettingsItemType.selection,
      title: title,
      icon: icon,
      value: currentValue,
      onTap: onTap,
    );
  }

  factory SettingsItem.action({
    required String title,
    String? subtitle,
    IconData? icon,
    Widget? trailing,
    required VoidCallback onTap,
    bool isDangerous = false,
  }) {
    return SettingsItem(
      type: SettingsItemType.action,
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: trailing,
      onTap: onTap,
      isDangerous: isDangerous,
    );
  }
}
