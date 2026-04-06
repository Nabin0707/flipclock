import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/empty_state.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/error_widget.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/loading_indicator.dart';
import 'package:flutter_clean_architecture/shared/widgets/pagination/pagination_widgets.dart';

// TODO: Customize list page template for your specific use case
/// Template for creating list pages with search, filter, and pagination
/// Use this as a base for creating feature-specific list pages
class ListPageTemplate<T> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function(int page, String search)? onLoadItems;
  final Widget Function(T item) itemBuilder;
  final bool showSearch;
  final bool showFilter;
  final Widget? filterWidget;
  final VoidCallback? onAddPressed;
  final String? emptyMessage;
  final String? emptySubtitle;
  final bool enablePagination;
  final int itemsPerPage;

  const ListPageTemplate({
    super.key,
    required this.title,
    this.onLoadItems,
    required this.itemBuilder,
    this.showSearch = true,
    this.showFilter = false,
    this.filterWidget,
    this.onAddPressed,
    this.emptyMessage,
    this.emptySubtitle,
    this.enablePagination = false,
    this.itemsPerPage = 20,
  });

  @override
  State<ListPageTemplate<T>> createState() => _ListPageTemplateState<T>();
}

class _ListPageTemplateState<T> extends State<ListPageTemplate<T>> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<T> _items = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreItems = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
    if (widget.enablePagination) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoadingMore && _hasMoreItems && widget.onLoadItems != null) {
        _loadMoreItems();
      }
    }
  }

  Future<void> _loadItems() async {
    if (widget.onLoadItems == null) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
    });

    try {
      final items =
          await widget.onLoadItems!(_currentPage, _searchController.text);
      setState(() {
        _items = items;
        _hasMoreItems = items.length >= widget.itemsPerPage;
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

  Future<void> _loadMoreItems() async {
    if (widget.onLoadItems == null) return;

    setState(() => _isLoadingMore = true);

    try {
      final items =
          await widget.onLoadItems!(_currentPage + 1, _searchController.text);
      setState(() {
        _items.addAll(items);
        _currentPage++;
        _hasMoreItems = items.length >= widget.itemsPerPage;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load more items: $e')),
        );
      }
    }
  }

  void _onSearchChanged(String value) {
    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == value) {
        _loadItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.showFilter && widget.filterWidget != null)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => widget.filterWidget!,
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _loadItems();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: widget.onAddPressed != null
          ? FloatingActionButton(
              onPressed: widget.onAddPressed,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (_hasError) {
      return Center(
        child: AppErrorWidget(
          message: _errorMessage ?? 'An error occurred',
          onAction: _loadItems,
        ),
      );
    }

    if (_items.isEmpty) {
      return EmptyState(
        message: widget.emptyMessage ?? 'No items found',
        subtitle: widget.emptySubtitle,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadItems,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount:
            _items.length + (widget.enablePagination && _hasMoreItems ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return LoadMoreIndicator(isLoading: _isLoadingMore);
          }
          return widget.itemBuilder(_items[index]);
        },
      ),
    );
  }
}
