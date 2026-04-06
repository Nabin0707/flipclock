// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationMetaImpl _$$PaginationMetaImplFromJson(Map<String, dynamic> json) =>
    _$PaginationMetaImpl(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      perPage: (json['perPage'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      lastPage: (json['lastPage'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] as bool? ?? true,
      firstItem: (json['from'] as num?)?.toInt(),
      lastItem: (json['to'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PaginationMetaImplToJson(
        _$PaginationMetaImpl instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'perPage': instance.perPage,
      'total': instance.total,
      'lastPage': instance.lastPage,
      'hasMore': instance.hasMore,
      'from': instance.firstItem,
      'to': instance.lastItem,
    };

_$PaginatedResponseImpl<T> _$$PaginatedResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$PaginatedResponseImpl<T>(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PaginatedResponseImplToJson<T>(
  _$PaginatedResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data.map(toJsonT).toList(),
      'meta': instance.meta,
    };

_$PaginationParamsImpl _$$PaginationParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationParamsImpl(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      search: json['search'] as String? ?? '',
      filters: json['filters'] as Map<String, dynamic>? ?? const {},
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String? ?? 'desc',
    );

Map<String, dynamic> _$$PaginationParamsImplToJson(
        _$PaginationParamsImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'search': instance.search,
      'filters': instance.filters,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
    };
