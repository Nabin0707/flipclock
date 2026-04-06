import 'package:dartz/dartz.dart';

// TODO: Extend Failure classes with specific error types for your app
/// Base failure class for error handling using functional programming approach
abstract class Failure {
  final String message;
  final int? statusCode;
  final dynamic error;

  const Failure({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() => message;
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
    super.error,
  });

  factory NetworkFailure.noInternet() => const NetworkFailure(
        message: 'No internet connection',
        statusCode: 0,
      );

  factory NetworkFailure.timeout() => const NetworkFailure(
        message: 'Connection timeout',
        statusCode: 408,
      );

  factory NetworkFailure.serverError() => const NetworkFailure(
        message: 'Server error occurred',
        statusCode: 500,
      );
}

/// Server-related failures (4xx, 5xx errors)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.error,
  });

  factory ServerFailure.badRequest() => const ServerFailure(
        message: 'Bad request',
        statusCode: 400,
      );

  factory ServerFailure.unauthorized() => const ServerFailure(
        message: 'Unauthorized access',
        statusCode: 401,
      );

  factory ServerFailure.forbidden() => const ServerFailure(
        message: 'Access forbidden',
        statusCode: 403,
      );

  factory ServerFailure.notFound() => const ServerFailure(
        message: 'Resource not found',
        statusCode: 404,
      );

  factory ServerFailure.internalError() => const ServerFailure(
        message: 'Internal server error',
        statusCode: 500,
      );
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.error,
  });

  factory CacheFailure.notFound() => const CacheFailure(
        message: 'Data not found in cache',
      );

  factory CacheFailure.writeError() => const CacheFailure(
        message: 'Failed to write to cache',
      );

  factory CacheFailure.readError() => const CacheFailure(
        message: 'Failed to read from cache',
      );
}

/// Validation-related failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
    super.error,
  });

  factory ValidationFailure.invalidInput(String field, String error) =>
      ValidationFailure(
        message: 'Invalid input',
        fieldErrors: {field: error},
      );

  factory ValidationFailure.multipleErrors(Map<String, String> errors) =>
      ValidationFailure(
        message: 'Multiple validation errors',
        fieldErrors: errors,
      );
}

/// Authentication/Authorization failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
    super.error,
  });

  factory AuthFailure.invalidCredentials() => const AuthFailure(
        message: 'Invalid email or password',
        statusCode: 401,
      );

  factory AuthFailure.tokenExpired() => const AuthFailure(
        message: 'Session expired, please login again',
        statusCode: 401,
      );

  factory AuthFailure.accountLocked() => const AuthFailure(
        message: 'Account has been locked',
        statusCode: 403,
      );
}

/// Generic/Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.error,
  });

  factory UnknownFailure.generic() => const UnknownFailure(
        message: 'An unexpected error occurred',
      );
}

/// Type alias for Result pattern using Either from dartz
/// Left = Failure, Right = Success
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result type
extension ResultX<T> on Result<T> {
  /// Check if result is successful
  bool get isSuccess => isRight();

  /// Check if result is failure
  bool get isFailure => isLeft();

  /// Get failure if exists
  Failure? get failure => fold((l) => l, (r) => null);

  /// Get success value if exists
  T? get value => fold((l) => null, (r) => r);
}
