import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for search functionality with debouncing
class SearchNotifier extends StateNotifier<String> {
  SearchNotifier({
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : super('');

  Timer? _debounce;
  final Duration debounceDuration;

  /// Update search query with debouncing
  void updateSearch(String query, {VoidCallback? onSearchComplete}) {
    // Cancel previous timer
    _debounce?.cancel();

    // Set timer for debounced search
    _debounce = Timer(debounceDuration, () {
      state = query;
      onSearchComplete?.call();
    });
  }

  /// Immediate search without debouncing
  void setSearchImmediate(String query) {
    _debounce?.cancel();
    state = query;
  }

  /// Clear search
  void clear() {
    _debounce?.cancel();
    state = '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

/// Provider for demo page search
final demoSearchProvider = StateNotifierProvider<SearchNotifier, String>((ref) {
  return SearchNotifier();
});

/// Provider for filtered demo components based on search
final filteredDemoComponentsProvider = Provider<List<String>>((ref) {
  final searchQuery = ref.watch(demoSearchProvider).toLowerCase();

  const allComponents = [
    'Buttons',
    'Inputs',
    'Cards',
    'Dialogs',
    'States',
    'Theme',
    'Templates',
    'Avatar',
    'Badge',
    'Chip',
    'Divider',
    'Rating',
    'Tag',
    'Timeline',
    'Pagination',
  ];

  if (searchQuery.isEmpty) {
    return allComponents;
  }

  return allComponents
      .where((component) => component.toLowerCase().contains(searchQuery))
      .toList();
});
