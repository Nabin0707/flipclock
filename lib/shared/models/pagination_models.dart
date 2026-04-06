import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_models.freezed.dart';
part 'pagination_models.g.dart';

// TODO: Customize pagination metadata based on your backend API
/// Pagination metadata containing pagination information
@freezed
class PaginationMeta with _$PaginationMeta {
  /// Default constructor
  const factory PaginationMeta({
    @Default(1) int currentPage,
    @Default(10) int perPage,
    @Default(0) int total,
    @Default(0) int lastPage,
    @Default(true) bool hasMore,
    @JsonKey(name: 'from') int? firstItem,
    @JsonKey(name: 'to') int? lastItem,
  }) = _PaginationMeta;

  /// Create from JSON
  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  /// Create initial pagination meta
  factory PaginationMeta.initial() => const PaginationMeta(
        currentPage: 1,
        perPage: 10,
        total: 0,
        lastPage: 0,
        hasMore: true,
      );
}

/// Paginated response wrapper
@Freezed(genericArgumentFactories: true)
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  /// Default constructor
  const factory PaginatedResponse({
    required List<T> data,
    required PaginationMeta meta,
  }) = _PaginatedResponse<T>;

  // Create from JSON
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  /// Create empty paginated response
  factory PaginatedResponse.empty() => PaginatedResponse(
        data: [],
        meta: PaginationMeta.initial(),
      );
}

/// Pagination state for UI
@freezed
class PaginationState<T> with _$PaginationState<T> {
  // Different states of pagination
  const factory PaginationState.initial() = _Initial;
  const factory PaginationState.loading() = _Loading;
  const factory PaginationState.loadingMore() = _LoadingMore;
  const factory PaginationState.success({
    required List<T> items,
    required PaginationMeta meta,
  }) = _Success<T>;
  const factory PaginationState.failure({
    required String message,
    List<T>? items,
  }) = _Failure<T>;
  const factory PaginationState.allLoaded({
    required List<T> items,
  }) = _AllLoaded<T>;
}

/// Pagination parameters for API requests
@freezed
class PaginationParams with _$PaginationParams {
  const factory PaginationParams({
    @Default(1) int page,
    @Default(10) int limit,
    @Default('') String search,
    @Default({}) Map<String, dynamic> filters,
    String? sortBy,
    @Default('desc') String sortOrder,
  }) = _PaginationParams;

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  /// Convert to query parameters
  factory PaginationParams.initial({int limit = 10}) => PaginationParams(
        page: 1,
        limit: limit,
      );
}

extension PaginationParamsX on PaginationParams {
  /// Convert to query parameters map
  Map<String, dynamic> toQueryParams() {
    return {
      'page': page,
      'limit': limit,
      if (search.isNotEmpty) 'search': search,
      if (sortBy != null) 'sort_by': sortBy,
      'sort_order': sortOrder,
      ...filters,
    };
  }

  /// Get next page parameters
  PaginationParams nextPage() => copyWith(page: page + 1);

  /// Reset to first page
  PaginationParams reset() => copyWith(page: 1);

  /// Update search
  PaginationParams withSearch(String newSearch) => copyWith(
        search: newSearch,
        page: 1, // Reset to first page on search
      );

  /// Update filters
  PaginationParams withFilters(Map<String, dynamic> newFilters) => copyWith(
        filters: newFilters,
        page: 1, // Reset to first page on filter change
      );
}
