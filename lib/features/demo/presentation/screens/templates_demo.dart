import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/templates/list_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/detail_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/form_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/profile_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/settings_page_template.dart';

/// Demo page to showcase all page templates
class TemplatesDemo extends StatelessWidget {
  const TemplatesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Templates Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Page Templates',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Reusable page templates for common UI patterns. '
            'Tap any card to see the template in action.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildTemplateCard(
            context,
            title: 'List Template',
            description: 'Search, filter, pagination, pull-to-refresh',
            icon: Icons.list,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _ListTemplateDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _buildTemplateCard(
            context,
            title: 'Detail Template',
            description: 'Structured detail view with actions',
            icon: Icons.description,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _DetailTemplateDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _buildTemplateCard(
            context,
            title: 'Form Template',
            description: 'Dynamic form with validation',
            icon: Icons.edit,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _FormTemplateDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _buildTemplateCard(
            context,
            title: 'Profile Template',
            description: 'User profile with stats and actions',
            icon: Icons.person,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _ProfileTemplateDemo()),
            ),
          ),
          const SizedBox(height: 16),
          _buildTemplateCard(
            context,
            title: 'Settings Template',
            description: 'Settings page with various item types',
            icon: Icons.settings,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _SettingsTemplateDemo()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

// Mock data model
class _MockItem {
  final String id;
  final String name;
  final String description;
  final String category;

  _MockItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
  });
}

/// List Template Demo
class _ListTemplateDemo extends StatelessWidget {
  const _ListTemplateDemo();

  @override
  Widget build(BuildContext context) {
    return ListPageTemplate<_MockItem>(
      title: 'Products',
      onLoadItems: (page, search) async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Generate mock data
        final items = List.generate(
          20,
          (index) => _MockItem(
            id: '${(page - 1) * 20 + index}',
            name: 'Product ${(page - 1) * 20 + index + 1}',
            description: 'This is a demo product',
            category: 'Category ${(index % 3) + 1}',
          ),
        );

        // Filter by search
        final filteredItems = search.isNotEmpty
            ? items
                .where((item) =>
                    item.name.toLowerCase().contains(search.toLowerCase()))
                .toList()
            : items;

        return filteredItems;
      },
      itemBuilder: (item) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(child: Text(item.id)),
          title: Text(item.name),
          subtitle: Text(item.description),
          trailing: Chip(label: Text(item.category)),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped ${item.name}')),
            );
          },
        ),
      ),
      showSearch: true,
      showFilter: false,
      enablePagination: true,
      emptyMessage: 'No products found',
    );
  }
}

/// Detail Template Demo
class _DetailTemplateDemo extends StatelessWidget {
  const _DetailTemplateDemo();

  @override
  Widget build(BuildContext context) {
    return DetailPageTemplate<_MockItem>(
      title: 'Product Details',
      onLoadData: () async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));
        return _MockItem(
          id: '1',
          name: 'Premium Headphones',
          description:
              'High-quality wireless headphones with noise cancellation',
          category: 'Electronics',
        );
      },
      contentBuilder: (item) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailSection(
            title: 'Basic Information',
            icon: Icons.info,
            child: Column(
              children: [
                DetailInfoRow(
                  label: 'Product Name',
                  value: item.name,
                  icon: Icons.shopping_bag,
                ),
                DetailInfoRow(
                  label: 'Category',
                  value: item.category,
                  icon: Icons.category,
                ),
                DetailInfoRow(
                  label: 'Description',
                  value: item.description,
                  icon: Icons.description,
                ),
              ],
            ),
          ),
        ],
      ),
      actionsBuilder: (item) => [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit tapped')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share tapped')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Delete tapped')),
            );
          },
        ),
      ],
      bottomBar: DetailActionsBar(
        primaryLabel: 'Add to Cart',
        secondaryLabel: 'Wishlist',
        primaryIcon: Icons.shopping_cart,
        secondaryIcon: Icons.favorite_border,
        onPrimaryAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to cart')),
          );
        },
        onSecondaryAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to wishlist')),
          );
        },
      ),
    );
  }
}

/// Form Template Demo
class _FormTemplateDemo extends StatelessWidget {
  const _FormTemplateDemo();

  @override
  Widget build(BuildContext context) {
    return FormPageTemplate(
      title: 'Create Product',
      fields: [
        FormFieldConfig(
          key: 'name',
          label: 'Product Name',
          hint: 'Enter product name',
          icon: Icons.shopping_bag,
          required: true,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Name is required' : null,
        ),
        FormFieldConfig(
          key: 'price',
          label: 'Price',
          hint: 'Enter price',
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          required: true,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Price is required';
            if (double.tryParse(value!) == null) return 'Invalid price';
            return null;
          },
        ),
        FormFieldConfig(
          key: 'description',
          label: 'Description',
          hint: 'Enter description',
          icon: Icons.description,
          maxLines: 4,
        ),
        FormFieldConfig(
          key: 'category',
          label: 'Category',
          hint: 'Select category',
          icon: Icons.category,
          required: true,
        ),
        FormFieldConfig(
          key: 'stock',
          label: 'Stock Quantity',
          hint: 'Enter quantity',
          icon: Icons.inventory,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Stock is required';
            if (int.tryParse(value!) == null) return 'Invalid quantity';
            return null;
          },
        ),
      ],
      onSubmit: (data) async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product created: ${data['name']}')),
          );
          Navigator.pop(context);
        }
      },
      onCancel: () {
        Navigator.pop(context);
      },
      submitButtonText: 'Create Product',
      cancelButtonText: 'Cancel',
    );
  }
}

/// Profile Template Demo
class _ProfileTemplateDemo extends StatelessWidget {
  const _ProfileTemplateDemo();

  @override
  Widget build(BuildContext context) {
    return ProfilePageTemplate(
      name: 'John Doe',
      subtitle: 'Software Developer',
      imageUrl: null, // Will show initials
      stats: [
        ProfileStat(label: 'Posts', value: '142'),
        ProfileStat(label: 'Followers', value: '1.2K'),
        ProfileStat(label: 'Following', value: '453'),
      ],
      actions: [
        ProfileAction(
          label: 'Message',
          icon: Icons.message,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message tapped')),
            );
          },
        ),
        ProfileAction(
          label: 'Share',
          icon: Icons.share,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share tapped')),
            );
          },
        ),
      ],
      infoItems: [
        ProfileInfoItem(
          label: 'Email',
          value: 'john.doe@example.com',
          icon: Icons.email,
        ),
        ProfileInfoItem(
          label: 'Phone',
          value: '+1 234 567 8900',
          icon: Icons.phone,
        ),
        ProfileInfoItem(
          label: 'Location',
          value: 'San Francisco, CA',
          icon: Icons.location_on,
        ),
        ProfileInfoItem(
          label: 'Member Since',
          value: 'January 2023',
          icon: Icons.calendar_today,
        ),
      ],
      onEditProfile: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit profile tapped')),
        );
      },
      onImageTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image tapped')),
        );
      },
    );
  }
}

/// Settings Template Demo
class _SettingsTemplateDemo extends StatelessWidget {
  const _SettingsTemplateDemo();

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: 'Settings',
      sections: [
        SettingsSection(
          title: 'Account',
          items: [
            SettingsItem.navigation(
              title: 'Profile',
              subtitle: 'Manage your profile',
              icon: Icons.person,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile tapped')),
                );
              },
            ),
            SettingsItem.navigation(
              title: 'Security',
              subtitle: 'Password and authentication',
              icon: Icons.security,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Security tapped')),
                );
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Preferences',
          items: [
            SettingsItem.toggle(
              title: 'Notifications',
              subtitle: 'Enable push notifications',
              icon: Icons.notifications,
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifications: $value')),
                );
              },
            ),
            SettingsItem.toggle(
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              icon: Icons.dark_mode,
              value: false,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dark mode: $value')),
                );
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'About',
          items: [
            SettingsItem.navigation(
              title: 'Help & Support',
              icon: Icons.help,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help tapped')),
                );
              },
            ),
            SettingsItem.navigation(
              title: 'About App',
              subtitle: 'Version 1.0.0',
              icon: Icons.info,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('About tapped')),
                );
              },
            ),
          ],
        ),
        SettingsSection(
          items: [
            SettingsItem.action(
              title: 'Logout',
              icon: Icons.logout,
              isDangerous: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout tapped')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
