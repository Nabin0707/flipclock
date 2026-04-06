import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

// TODO: Customize ApiResponse based on your backend API structure
/// Generic API response wrapper for handling API responses consistently
/// Contains status code, message, and optional data payload
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required int statusCode,
    required String message,
    T? data,
    Map<String, dynamic>? errors,
    @JsonKey(name: 'meta') Map<String, dynamic>? metadata,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

/// Success response wrapper
@Freezed(genericArgumentFactories: true)
class ApiSuccess<T> with _$ApiSuccess<T> {
  const factory ApiSuccess({
    required T data,
    String? message,
  }) = _ApiSuccess<T>;

  factory ApiSuccess.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiSuccessFromJson(json, fromJsonT);
}

/// Error response wrapper
@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required int statusCode,
    required String message,
    Map<String, dynamic>? errors,
    String? errorCode,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}
