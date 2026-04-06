import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/loading_indicator.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/error_widget.dart';

// TODO: Customize detail page template for specific features
/// Template for creating detail/view pages with loading and error states
/// Use this as a base for product details, user profiles, article views, etc.
class DetailPageTemplate<T> extends StatefulWidget {
  final String title;
  final Future<T> Function()? onLoadData;
  final Widget Function(T data) contentBuilder;
  final List<Widget> Function(T data)? actionsBuilder;
  final Widget? bottomBar;
  final bool showAppBar;

  const DetailPageTemplate({
    super.key,
    required this.title,
    this.onLoadData,
    required this.contentBuilder,
    this.actionsBuilder,
    this.bottomBar,
    this.showAppBar = true,
  });

  @override
  State<DetailPageTemplate<T>> createState() => _DetailPageTemplateState<T>();
}

class _DetailPageTemplateState<T> extends State<DetailPageTemplate<T>> {
  T? _data;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.onLoadData == null) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final data = await widget.onLoadData!();
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title),
              actions: _data != null && widget.actionsBuilder != null
                  ? widget.actionsBuilder!(_data!)
                  : null,
            )
          : null,
      body: _buildBody(),
      bottomNavigationBar: _data != null ? widget.bottomBar : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (_hasError) {
      return Center(
        child: AppErrorWidget(
          message: _errorMessage ?? 'Failed to load data',
          onAction: _loadData,
        ),
      );
    }

    if (_data == null) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: widget.contentBuilder(_data!),
      ),
    );
  }
}

/// Section widget for organizing detail page content
class DetailSection extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final EdgeInsets? padding;
  final bool showDivider;

  const DetailSection({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.padding,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Text(
                  title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
      ],
    );
  }
}

/// Info row for key-value pairs
class DetailInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final VoidCallback? onTap;

  const DetailInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Action buttons bar for detail pages
class DetailActionsBar extends StatelessWidget {
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final String primaryLabel;
  final String? secondaryLabel;
  final IconData? primaryIcon;
  final IconData? secondaryIcon;

  const DetailActionsBar({
    super.key,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryLabel = 'Save',
    this.secondaryLabel,
    this.primaryIcon,
    this.secondaryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (secondaryLabel != null) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSecondaryAction,
                  icon: secondaryIcon != null
                      ? Icon(secondaryIcon)
                      : const SizedBox.shrink(),
                  label: Text(secondaryLabel!),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: secondaryLabel != null ? 1 : 2,
              child: PrimaryButton(
                text: primaryLabel,
                icon: primaryIcon,
                onPressed: onPrimaryAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
