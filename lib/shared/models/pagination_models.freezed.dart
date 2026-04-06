// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) {
  return _PaginationMeta.fromJson(json);
}

/// @nodoc
mixin _$PaginationMeta {
  int get currentPage => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get lastPage => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  @JsonKey(name: 'from')
  int? get firstItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'to')
  int? get lastItem => throw _privateConstructorUsedError;

  /// Serializes this PaginationMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationMetaCopyWith<PaginationMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationMetaCopyWith<$Res> {
  factory $PaginationMetaCopyWith(
          PaginationMeta value, $Res Function(PaginationMeta) then) =
      _$PaginationMetaCopyWithImpl<$Res, PaginationMeta>;
  @useResult
  $Res call(
      {int currentPage,
      int perPage,
      int total,
      int lastPage,
      bool hasMore,
      @JsonKey(name: 'from') int? firstItem,
      @JsonKey(name: 'to') int? lastItem});
}

/// @nodoc
class _$PaginationMetaCopyWithImpl<$Res, $Val extends PaginationMeta>
    implements $PaginationMetaCopyWith<$Res> {
  _$PaginationMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? perPage = null,
    Object? total = null,
    Object? lastPage = null,
    Object? hasMore = null,
    Object? firstItem = freezed,
    Object? lastItem = freezed,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      firstItem: freezed == firstItem
          ? _value.firstItem
          : firstItem // ignore: cast_nullable_to_non_nullable
              as int?,
      lastItem: freezed == lastItem
          ? _value.lastItem
          : lastItem // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationMetaImplCopyWith<$Res>
    implements $PaginationMetaCopyWith<$Res> {
  factory _$$PaginationMetaImplCopyWith(_$PaginationMetaImpl value,
          $Res Function(_$PaginationMetaImpl) then) =
      __$$PaginationMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentPage,
      int perPage,
      int total,
      int lastPage,
      bool hasMore,
      @JsonKey(name: 'from') int? firstItem,
      @JsonKey(name: 'to') int? lastItem});
}

/// @nodoc
class __$$PaginationMetaImplCopyWithImpl<$Res>
    extends _$PaginationMetaCopyWithImpl<$Res, _$PaginationMetaImpl>
    implements _$$PaginationMetaImplCopyWith<$Res> {
  __$$PaginationMetaImplCopyWithImpl(
      _$PaginationMetaImpl _value, $Res Function(_$PaginationMetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? perPage = null,
    Object? total = null,
    Object? lastPage = null,
    Object? hasMore = null,
    Object? firstItem = freezed,
    Object? lastItem = freezed,
  }) {
    return _then(_$PaginationMetaImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      firstItem: freezed == firstItem
          ? _value.firstItem
          : firstItem // ignore: cast_nullable_to_non_nullable
              as int?,
      lastItem: freezed == lastItem
          ? _value.lastItem
          : lastItem // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationMetaImpl implements _PaginationMeta {
  const _$PaginationMetaImpl(
      {this.currentPage = 1,
      this.perPage = 10,
      this.total = 0,
      this.lastPage = 0,
      this.hasMore = true,
      @JsonKey(name: 'from') this.firstItem,
      @JsonKey(name: 'to') this.lastItem});

  factory _$PaginationMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationMetaImplFromJson(json);

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int perPage;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int lastPage;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey(name: 'from')
  final int? firstItem;
  @override
  @JsonKey(name: 'to')
  final int? lastItem;

  @override
  String toString() {
    return 'PaginationMeta(currentPage: $currentPage, perPage: $perPage, total: $total, lastPage: $lastPage, hasMore: $hasMore, firstItem: $firstItem, lastItem: $lastItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationMetaImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.firstItem, firstItem) ||
                other.firstItem == firstItem) &&
            (identical(other.lastItem, lastItem) ||
                other.lastItem == lastItem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPage, perPage, total,
      lastPage, hasMore, firstItem, lastItem);

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationMetaImplCopyWith<_$PaginationMetaImpl> get copyWith =>
      __$$PaginationMetaImplCopyWithImpl<_$PaginationMetaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationMetaImplToJson(
      this,
    );
  }
}

abstract class _PaginationMeta implements PaginationMeta {
  const factory _PaginationMeta(
      {final int currentPage,
      final int perPage,
      final int total,
      final int lastPage,
      final bool hasMore,
      @JsonKey(name: 'from') final int? firstItem,
      @JsonKey(name: 'to') final int? lastItem}) = _$PaginationMetaImpl;

  factory _PaginationMeta.fromJson(Map<String, dynamic> json) =
      _$PaginationMetaImpl.fromJson;

  @override
  int get currentPage;
  @override
  int get perPage;
  @override
  int get total;
  @override
  int get lastPage;
  @override
  bool get hasMore;
  @override
  @JsonKey(name: 'from')
  int? get firstItem;
  @override
  @JsonKey(name: 'to')
  int? get lastItem;

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationMetaImplCopyWith<_$PaginationMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _PaginatedResponse<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$PaginatedResponse<T> {
  List<T> get data => throw _privateConstructorUsedError;
  PaginationMeta get meta => throw _privateConstructorUsedError;

  /// Serializes this PaginatedResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedResponseCopyWith<T, PaginatedResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedResponseCopyWith<T, $Res> {
  factory $PaginatedResponseCopyWith(PaginatedResponse<T> value,
          $Res Function(PaginatedResponse<T>) then) =
      _$PaginatedResponseCopyWithImpl<T, $Res, PaginatedResponse<T>>;
  @useResult
  $Res call({List<T> data, PaginationMeta meta});

  $PaginationMetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$PaginatedResponseCopyWithImpl<T, $Res,
        $Val extends PaginatedResponse<T>>
    implements $PaginatedResponseCopyWith<T, $Res> {
  _$PaginatedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PaginationMeta,
    ) as $Val);
  }

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationMetaCopyWith<$Res> get meta {
    return $PaginationMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaginatedResponseImplCopyWith<T, $Res>
    implements $PaginatedResponseCopyWith<T, $Res> {
  factory _$$PaginatedResponseImplCopyWith(_$PaginatedResponseImpl<T> value,
          $Res Function(_$PaginatedResponseImpl<T>) then) =
      __$$PaginatedResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> data, PaginationMeta meta});

  @override
  $PaginationMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$PaginatedResponseImplCopyWithImpl<T, $Res>
    extends _$PaginatedResponseCopyWithImpl<T, $Res, _$PaginatedResponseImpl<T>>
    implements _$$PaginatedResponseImplCopyWith<T, $Res> {
  __$$PaginatedResponseImplCopyWithImpl(_$PaginatedResponseImpl<T> _value,
      $Res Function(_$PaginatedResponseImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = null,
  }) {
    return _then(_$PaginatedResponseImpl<T>(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PaginationMeta,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$PaginatedResponseImpl<T> implements _PaginatedResponse<T> {
  const _$PaginatedResponseImpl(
      {required final List<T> data, required this.meta})
      : _data = data;

  factory _$PaginatedResponseImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$PaginatedResponseImplFromJson(json, fromJsonT);

  final List<T> _data;
  @override
  List<T> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PaginationMeta meta;

  @override
  String toString() {
    return 'PaginatedResponse<$T>(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedResponseImpl<T> &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), meta);

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedResponseImplCopyWith<T, _$PaginatedResponseImpl<T>>
      get copyWith =>
          __$$PaginatedResponseImplCopyWithImpl<T, _$PaginatedResponseImpl<T>>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$PaginatedResponseImplToJson<T>(this, toJsonT);
  }
}

abstract class _PaginatedResponse<T> implements PaginatedResponse<T> {
  const factory _PaginatedResponse(
      {required final List<T> data,
      required final PaginationMeta meta}) = _$PaginatedResponseImpl<T>;

  factory _PaginatedResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$PaginatedResponseImpl<T>.fromJson;

  @override
  List<T> get data;
  @override
  PaginationMeta get meta;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedResponseImplCopyWith<T, _$PaginatedResponseImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaginationState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() loadingMore,
    required TResult Function(List<T> items, PaginationMeta meta) success,
    required TResult Function(String message, List<T>? items) failure,
    required TResult Function(List<T> items) allLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? loadingMore,
    TResult? Function(List<T> items, PaginationMeta meta)? success,
    TResult? Function(String message, List<T>? items)? failure,
    TResult? Function(List<T> items)? allLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? loadingMore,
    TResult Function(List<T> items, PaginationMeta meta)? success,
    TResult Function(String message, List<T>? items)? failure,
    TResult Function(List<T> items)? allLoaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_LoadingMore<T> value) loadingMore,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_Failure<T> value) failure,
    required TResult Function(_AllLoaded<T> value) allLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_LoadingMore<T> value)? loadingMore,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_Failure<T> value)? failure,
    TResult? Function(_AllLoaded<T> value)? allLoaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_LoadingMore<T> value)? loadingMore,
    TResult Function(_Success<T> value)? success,
    TResult Function(_Failure<T> value)? failure,
    TResult Function(_AllLoaded<T> value)? allLoaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationStateCopyWith<T, $Res> {
  factory $PaginationStateCopyWith(
          PaginationState<T> value, $Res Function(PaginationState<T>) then) =
      _$PaginationStateCopyWithImpl<T, $Res, PaginationState<T>>;
}

/// @nodoc
class _$PaginationStateCopyWithImpl<T, $Res, $Val extends PaginationState<T>>
    implements $PaginationStateCopyWith<T, $Res> {
  _$PaginationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<T, $Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl<T> value, $Res Function(_$InitialImpl<T>) then) =
      __$$InitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$InitialImpl<T>>
    implements _$$InitialImplCopyWith<T, $Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl<T> _value, $Res Function(_$InitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl<T> implements _Initial<T> {
  const _$InitialImpl();

  @override
  String toString() {
    return 'PaginationState<$T>.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() loadingMore,
    required TResult Function(List<T> items, PaginationMeta meta) success,
    required TResult Function(String message, List<T>? items) failure,
    required TResult Function(List<T> items) allLoaded,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? loadingMore,
    TResult? Function(List<T> items, PaginationMeta meta)? success,
    TResult? Function(String message, List<T>? items)? failure,
    TResult? Function(List<T> items)? allLoaded,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? loadingMore,
    TResult Function(List<T> items, PaginationMeta meta)? success,
    TResult Function(String message, List<T>? items)? failure,
    TResult Function(List<T> items)? allLoaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_LoadingMore<T> value) loadingMore,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_Failure<T> value) failure,
    required TResult Function(_AllLoaded<T> value) allLoaded,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_LoadingMore<T> value)? loadingMore,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_Failure<T> value)? failure,
    TResult? Function(_AllLoaded<T> value)? allLoaded,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_LoadingMore<T> value)? loadingMore,
    TResult Function(_Success<T> value)? success,
    TResult Function(_Failure<T> value)? failure,
    TResult Function(_AllLoaded<T> value)? allLoaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial<T> implements PaginationState<T> {
  const factory _Initial() = _$InitialImpl<T>;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<T, $Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl<T> value, $Res Function(_$LoadingImpl<T>) then) =
      __$$LoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$LoadingImpl<T>>
    implements _$$LoadingImplCopyWith<T, $Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl<T> _value, $Res Function(_$LoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl<T> implements _Loading<T> {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'PaginationState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() loadingMore,
    required TResult Function(List<T> items, PaginationMeta meta) success,
    required TResult Function(String message, List<T>? items) failure,
    required TResult Function(List<T> items) allLoaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? loadingMore,
    TResult? Function(List<T> items, PaginationMeta meta)? success,
    TResult? Function(String message, List<T>? items)? failure,
    TResult? Function(List<T> items)? allLoaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? loadingMore,
    TResult Function(List<T> items, PaginationMeta meta)? success,
    TResult Function(String message, List<T>? items)? failure,
    TResult Function(List<T> items)? allLoaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_LoadingMore<T> value) loadingMore,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_Failure<T> value) failure,
    required TResult Function(_AllLoaded<T> value) allLoaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_LoadingMore<T> value)? loadingMore,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_Failure<T> value)? failure,
    TResult? Function(_AllLoaded<T> value)? allLoaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_LoadingMore<T> value)? loadingMore,
    TResult Function(_Success<T> value)? success,
    TResult Function(_Failure<T> value)? failure,
    TResult Function(_AllLoaded<T> value)? allLoaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading<T> implements PaginationState<T> {
  const factory _Loading() = _$LoadingImpl<T>;
}

/// @nodoc
abstract class _$$LoadingMoreImplCopyWith<T, $Res> {
  factory _$$LoadingMoreImplCopyWith(_$LoadingMoreImpl<T> value,
          $Res Function(_$LoadingMoreImpl<T>) then) =
      __$$LoadingMoreImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingMoreImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$LoadingMoreImpl<T>>
    implements _$$LoadingMoreImplCopyWith<T, $Res> {
  __$$LoadingMoreImplCopyWithImpl(
      _$LoadingMoreImpl<T> _value, $Res Function(_$LoadingMoreImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingMoreImpl<T> implements _LoadingMore<T> {
  const _$LoadingMoreImpl();

  @override
  String toString() {
    return 'PaginationState<$T>.loadingMore()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingMoreImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() loadingMore,
    required TResult Function(List<T> items, PaginationMeta meta) success,
    required TResult Function(String message, List<T>? items) failure,
    required TResult Function(List<T> items) allLoaded,
  }) {
    return loadingMore();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? loadingMore,
    TResult? Function(List<T> items, PaginationMeta meta)? success,
    TResult? Function(String message, List<T>? items)? failure,
    TResult? Function(List<T> items)? allLoaded,
  }) {
    return loadingMore?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? loadingMore,
    TResult Function(List<T> items, PaginationMeta meta)? success,
    TResult Function(String message, List<T>? items)? failure,
    TResult Function(List<T> items)? allLoaded,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_LoadingMore<T> value) loadingMore,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_Failure<T> value) failure,
    required TResult Function(_AllLoaded<T> value) allLoaded,
  }) {
    return loadingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_LoadingMore<T> value)? loadingMore,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_Failure<T> value)? failure,
    TResult? Function(_AllLoaded<T> value)? allLoaded,
  }) {
    return loadingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_LoadingMore<T> value)? loadingMore,
    TResult Function(_Success<T> value)? success,
    TResult Function(_Failure<T> value)? failure,
    TResult Function(_AllLoaded<T> value)? allLoaded,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this);
    }
    return orElse();
  }
}

abstract class _LoadingMore<T> implements PaginationState<T> {
  const factory _LoadingMore() = _$LoadingMoreImpl<T>;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<T, $Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl<T> value, $Res Function(_$SuccessImpl<T>) then) =
      __$$SuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> items, PaginationMeta meta});

  $PaginationMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$SuccessImpl<T>>
    implements _$$SuccessImplCopyWith<T, $Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl<T> _value, $Res Function(_$SuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? meta = null,
  }) {
    return _then(_$SuccessImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PaginationMeta,
    ));
  }

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationMetaCopyWith<$Res> get meta {
    return $PaginationMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value));
    });
  }
}

/// @nodoc

class _$SuccessImpl<T> implements _Success<T> {
  const _$SuccessImpl({required final List<T> items, required this.meta})
      : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final PaginationMeta meta;

  @override
  String toString() {
    return 'PaginationState<$T>.success(items: $items, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), meta);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<T, _$SuccessImpl<T>> get copyWith =>
      __$$SuccessImplCopyWithImpl<T, _$SuccessImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() loadingMore,
    required TResult Function(List<T> items, PaginationMeta meta) success,
    required TResult Function(String message, List<T>? items) failure,
    required TResult Function(List<T> items) allLoaded,
  }) {
    return success(items, meta);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? loadingMore,
    TResult? Function(List<T> items, PaginationMeta meta)? success,
    TResult? Function(String message, List<T>? items)? failure,
    TResult? Function(List<T> items)? allLoaded,
  }) {
    return success?.call(items, meta);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? loadingMore,
    TResult Function(List<T> items, PaginationMeta meta)? success,
    TResult Function(String message, List<T>? items)? failure,
    TResult Function(List<T> items)? allLoaded,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(items, meta);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_LoadingMore<T> value) loadingMore,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_Failure<T> value) failure,
    required TResult Function(_AllLoaded<T> value) allLoaded,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_LoadingMore<T> value)? loadingMore,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_Failure<T> value)? failure,
    TResult? Function(_AllLoaded<T> value)? allLoaded,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_LoadingMore<T> value)? loadingMore,
    TResult Function(_Success<T> value)? success,
    TResult Function(_Failure<T> value)? failure,
    TResult Function(_AllLoaded<T> value)? allLoaded,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success<T> implements PaginationState<T> {
  const factory _Success(
      {required final List<T> items,
      required final PaginationMeta meta}) = _$SuccessImpl<T>;

  List<T> get items;
  PaginationMeta get meta;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<T, _$SuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailureImplCopyWith<T, $Res> {
  factory _$$FailureImplCopyWith(
          _$FailureImpl<T> value, $Res Function(_$FailureImpl<T>) then) =
      __$$FailureImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String message, List<T>? items});
}

/// @nodoc
class __$$FailureImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$FailureImpl<T>>
    implements _$$FailureImplCopyWith<T, $Res> {
  __$$FailureImplCopyWithImpl(
      _$FailureImpl<T> _value, $Res Function(_$FailureImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? items = freezed,
  }) {
    return _then(_$FailureImpl<T>(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>?,
    ));
  }
}

/// @nodoc

class _$FailureImpl<T> implements _Failure<T> {
  const _$FailureImpl({required this.message, final List<T>? items})
      : _items = items;

  @override
  final String message;
  final List<T>? _items;
  @override
  List<T>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PaginationState<$T>.failure(message: $message, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureImpl<T> &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_items));

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureImplCopyWith<T, _$FailureImpl<T>> get copyWith =>
      __$$FailureImplCopyWithImpl<T, _$FailureImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() loadingMore,
    required TResult Function(List<T> items, PaginationMeta meta) success,
    required TResult Function(String message, List<T>? items) failure,
    required TResult Function(List<T> items) allLoaded,
  }) {
    return failure(message, items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? loadingMore,
    TResult? Function(List<T> items, PaginationMeta meta)? success,
    TResult? Function(String message, List<T>? items)? failure,
    TResult? Function(List<T> items)? allLoaded,
  }) {
    return failure?.call(message, items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? loadingMore,
    TResult Function(List<T> items, PaginationMeta meta)? success,
    TResult Function(String message, List<T>? items)? failure,
    TResult Function(List<T> items)? allLoaded,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message, items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_LoadingMore<T> value) loadingMore,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_Failure<T> value) failure,
    required TResult Function(_AllLoaded<T> value) allLoaded,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_LoadingMore<T> value)? loadingMore,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_Failure<T> value)? failure,
    TResult? Function(_AllLoaded<T> value)? allLoaded,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_LoadingMore<T> value)? loadingMore,
    TResult Function(_Success<T> value)? success,
    TResult Function(_Failure<T> value)? failure,
    TResult Function(_AllLoaded<T> value)? allLoaded,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _Failure<T> implements PaginationState<T> {
  const factory _Failure(
      {required final String message, final List<T>? items}) = _$FailureImpl<T>;

  String get message;
  List<T>? get items;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailureImplCopyWith<T, _$FailureImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AllLoadedImplCopyWith<T, $Res> {
  factory _$$AllLoadedImplCopyWith(
          _$AllLoadedImpl<T> value, $Res Function(_$AllLoadedImpl<T>) then) =
      __$$AllLoadedImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> items});
}

/// @nodoc
class __$$AllLoadedImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$AllLoadedImpl<T>>
    implements _$$AllLoadedImplCopyWith<T, $Res> {
  __$$AllLoadedImplCopyWithImpl(
      _$AllLoadedImpl<T> _value, $Res Function(_$AllLoadedImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$AllLoadedImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$AllLoadedImpl<T> implements _AllLoaded<T> {
  const _$AllLoadedImpl({required final List<T> items}) : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginationState<$T>.allLoaded(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllLoadedImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AllLoadedImplCopyWith<T, _$AllLoadedImpl<T>> get copyWith =>
      __$$AllLoadedImplCopyWithImpl<T, _$AllLoadedImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() loadingMore,
    required TResult Function(List<T> items, PaginationMeta meta) success,
    required TResult Function(String message, List<T>? items) failure,
    required TResult Function(List<T> items) allLoaded,
  }) {
    return allLoaded(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? loadingMore,
    TResult? Function(List<T> items, PaginationMeta meta)? success,
    TResult? Function(String message, List<T>? items)? failure,
    TResult? Function(List<T> items)? allLoaded,
  }) {
    return allLoaded?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? loadingMore,
    TResult Function(List<T> items, PaginationMeta meta)? success,
    TResult Function(String message, List<T>? items)? failure,
    TResult Function(List<T> items)? allLoaded,
    required TResult orElse(),
  }) {
    if (allLoaded != null) {
      return allLoaded(items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_LoadingMore<T> value) loadingMore,
    required TResult Function(_Success<T> value) success,
    required TResult Function(_Failure<T> value) failure,
    required TResult Function(_AllLoaded<T> value) allLoaded,
  }) {
    return allLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_LoadingMore<T> value)? loadingMore,
    TResult? Function(_Success<T> value)? success,
    TResult? Function(_Failure<T> value)? failure,
    TResult? Function(_AllLoaded<T> value)? allLoaded,
  }) {
    return allLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_LoadingMore<T> value)? loadingMore,
    TResult Function(_Success<T> value)? success,
    TResult Function(_Failure<T> value)? failure,
    TResult Function(_AllLoaded<T> value)? allLoaded,
    required TResult orElse(),
  }) {
    if (allLoaded != null) {
      return allLoaded(this);
    }
    return orElse();
  }
}

abstract class _AllLoaded<T> implements PaginationState<T> {
  const factory _AllLoaded({required final List<T> items}) = _$AllLoadedImpl<T>;

  List<T> get items;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AllLoadedImplCopyWith<T, _$AllLoadedImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) {
  return _PaginationParams.fromJson(json);
}

/// @nodoc
mixin _$PaginationParams {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  String get search => throw _privateConstructorUsedError;
  Map<String, dynamic> get filters => throw _privateConstructorUsedError;
  String? get sortBy => throw _privateConstructorUsedError;
  String get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this PaginationParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationParamsCopyWith<PaginationParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationParamsCopyWith<$Res> {
  factory $PaginationParamsCopyWith(
          PaginationParams value, $Res Function(PaginationParams) then) =
      _$PaginationParamsCopyWithImpl<$Res, PaginationParams>;
  @useResult
  $Res call(
      {int page,
      int limit,
      String search,
      Map<String, dynamic> filters,
      String? sortBy,
      String sortOrder});
}

/// @nodoc
class _$PaginationParamsCopyWithImpl<$Res, $Val extends PaginationParams>
    implements $PaginationParamsCopyWith<$Res> {
  _$PaginationParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? search = null,
    Object? filters = null,
    Object? sortBy = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationParamsImplCopyWith<$Res>
    implements $PaginationParamsCopyWith<$Res> {
  factory _$$PaginationParamsImplCopyWith(_$PaginationParamsImpl value,
          $Res Function(_$PaginationParamsImpl) then) =
      __$$PaginationParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int limit,
      String search,
      Map<String, dynamic> filters,
      String? sortBy,
      String sortOrder});
}

/// @nodoc
class __$$PaginationParamsImplCopyWithImpl<$Res>
    extends _$PaginationParamsCopyWithImpl<$Res, _$PaginationParamsImpl>
    implements _$$PaginationParamsImplCopyWith<$Res> {
  __$$PaginationParamsImplCopyWithImpl(_$PaginationParamsImpl _value,
      $Res Function(_$PaginationParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? search = null,
    Object? filters = null,
    Object? sortBy = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_$PaginationParamsImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationParamsImpl implements _PaginationParams {
  const _$PaginationParamsImpl(
      {this.page = 1,
      this.limit = 10,
      this.search = '',
      final Map<String, dynamic> filters = const {},
      this.sortBy,
      this.sortOrder = 'desc'})
      : _filters = filters;

  factory _$PaginationParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationParamsImplFromJson(json);

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final String search;
  final Map<String, dynamic> _filters;
  @override
  @JsonKey()
  Map<String, dynamic> get filters {
    if (_filters is EqualUnmodifiableMapView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_filters);
  }

  @override
  final String? sortBy;
  @override
  @JsonKey()
  final String sortOrder;

  @override
  String toString() {
    return 'PaginationParams(page: $page, limit: $limit, search: $search, filters: $filters, sortBy: $sortBy, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationParamsImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.search, search) || other.search == search) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, limit, search,
      const DeepCollectionEquality().hash(_filters), sortBy, sortOrder);

  /// Create a copy of PaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationParamsImplCopyWith<_$PaginationParamsImpl> get copyWith =>
      __$$PaginationParamsImplCopyWithImpl<_$PaginationParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationParamsImplToJson(
      this,
    );
  }
}

abstract class _PaginationParams implements PaginationParams {
  const factory _PaginationParams(
      {final int page,
      final int limit,
      final String search,
      final Map<String, dynamic> filters,
      final String? sortBy,
      final String sortOrder}) = _$PaginationParamsImpl;

  factory _PaginationParams.fromJson(Map<String, dynamic> json) =
      _$PaginationParamsImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  String get search;
  @override
  Map<String, dynamic> get filters;
  @override
  String? get sortBy;
  @override
  String get sortOrder;

  /// Create a copy of PaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationParamsImplCopyWith<_$PaginationParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
