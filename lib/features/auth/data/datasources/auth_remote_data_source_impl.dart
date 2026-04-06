import 'package:flutter_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/auth/data/models/user_model.dart';

/// Mock implementation of Remote Data Source for testing
/// Replace this with actual API implementation
class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  UserModel? _currentUser;

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    // Mock validation - accept both test credentials and admin credentials
    if ((email != 'test@example.com' || password != 'password123') &&
        (email != 'admin' || password != 'admin')) {
      throw Exception('invalid-credentials');
    }

    _currentUser = UserModel(
      id: email == 'admin' ? 'admin' : '1',
      email: email,
      name: email == 'admin' ? 'Admin User' : 'Test User',
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Mock email already exists check - don't allow admin email for registration
    if (email == 'test@example.com' || email == 'admin') {
      throw Exception('email-already-in-use');
    }

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
