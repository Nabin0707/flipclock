import 'dart:convert';

import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements IAuthLocalDataSource {
  AuthLocalDataSourceImpl(this._prefs);
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _rememberMeKey = 'REMEMBER_ME';
  static const String _cachedEmailKey = 'CACHED_EMAIL';
  static const String _cachedPasswordKey = 'CACHED_PASSWORD';

  final SharedPreferences _prefs;

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_cachedUserKey, json.encode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _prefs.getString(_cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cachedUserKey);
  }

  @override
  Future<void> setRememberMe(bool remember) async {
    await _prefs.setBool(_rememberMeKey, remember);
  }

  @override
  Future<bool> getRememberMe() async {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  @override
  Future<void> cacheCredentials(String email, String password) async {
    await _prefs.setString(_cachedEmailKey, email);
    await _prefs.setString(_cachedPasswordKey, password);
  }

  @override
  Future<Map<String, String>?> getCachedCredentials() async {
    final email = _prefs.getString(_cachedEmailKey);
    final password = _prefs.getString(_cachedPasswordKey);

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  @override
  Future<void> clearCredentials() async {
    await _prefs.remove(_cachedEmailKey);
    await _prefs.remove(_cachedPasswordKey);
  }
}
