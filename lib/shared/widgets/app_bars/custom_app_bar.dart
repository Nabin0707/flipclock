import 'package:flutter/material.dart';

// TODO: Add custom app bar animations and scroll behaviors
/// Custom app bar with standard appearance
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// App bar with search field
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showSearchByDefault;

  const SearchAppBar({
    super.key,
    required this.title,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.leading,
    this.actions,
    this.showSearchByDefault = false,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late bool _isSearching;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSearching = widget.showSearchByDefault;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      widget.onSearchChanged?.call('');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.searchHint,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withValues(alpha: 0.6),
            ),
          ),
          style: Theme.of(context).textTheme.titleMedium,
          onChanged: widget.onSearchChanged,
          onSubmitted: (_) => widget.onSearchSubmitted?.call(),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                widget.onSearchChanged?.call('');
              },
            ),
        ],
      );
    }

    return AppBar(
      title: Text(widget.title),
      leading: widget.leading,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
        ...?widget.actions,
      ],
    );
  }
}

/// App bar with theme toggle action
class ThemeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final VoidCallback? onThemeToggle;

  const ThemeAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(title),
      leading: leading,
      centerTitle: centerTitle,
      actions: [
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: onThemeToggle,
          tooltip: isDark ? 'Light Mode' : 'Dark Mode',
        ),
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// App bar with tabs
class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> tabs;
  final TabController? controller;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const TabAppBar({
    super.key,
    required this.title,
    required this.tabs,
    this.controller,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      centerTitle: centerTitle,
      actions: actions,
      bottom: TabBar(
        controller: controller,
        tabs: tabs,
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
