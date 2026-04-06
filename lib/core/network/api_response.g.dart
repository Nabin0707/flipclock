// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl<T> _$$ApiResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiResponseImpl<T>(
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      errors: json['errors'] as Map<String, dynamic>?,
      metadata: json['meta'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ApiResponseImplToJson<T>(
  _$ApiResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'errors': instance.errors,
      'meta': instance.metadata,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

_$ApiSuccessImpl<T> _$$ApiSuccessImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiSuccessImpl<T>(
      data: fromJsonT(json['data']),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ApiSuccessImplToJson<T>(
  _$ApiSuccessImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
      'message': instance.message,
    };

_$ApiErrorImpl _$$ApiErrorImplFromJson(Map<String, dynamic> json) =>
    _$ApiErrorImpl(
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      errors: json['errors'] as Map<String, dynamic>?,
      errorCode: json['errorCode'] as String?,
    );

Map<String, dynamic> _$$ApiErrorImplToJson(_$ApiErrorImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'errors': instance.errors,
      'errorCode': instance.errorCode,
    };
