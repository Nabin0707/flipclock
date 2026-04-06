import 'package:flutter_clean_architecture/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_notifier.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.error(String message) = _Error;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.unauthenticated()) {
    checkAuthStatus();
  }
  final IAuthRepository _repository;

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    final userOption = await _repository.getCurrentUser();
    state = userOption.fold(
      () => const AuthState.unauthenticated(),
      AuthState.authenticated,
    );
  }

  Future<void> signIn(String email, String password,
      {bool rememberMe = false}) async {
    state = const AuthState.loading();
    final result = await _repository.signIn(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => state = AuthState.error(failure.toString()),
      (user) async {
        if (rememberMe) {
          await _repository.cacheCredentials(email, password);
          await _repository.setRememberMe(true);
        } else {
          await _repository.clearCredentials();
          await _repository.setRememberMe(false);
        }
        state = AuthState.authenticated(user);
      },
    );
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AuthState.loading();
    final result = await _repository.signUp(
      email: email,
      password: password,
      name: name,
    );
    state = result.fold(
      (failure) => AuthState.error(failure.toString()),
      AuthState.authenticated,
    );
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    final result = await _repository.signOut();
    result.fold(
      (failure) => state = AuthState.error(failure.toString()),
      (_) => state = const AuthState.unauthenticated(),
    );
  }
}
