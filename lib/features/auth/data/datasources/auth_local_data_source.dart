import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final String validEmail;
  final String validPassword;
  final String userName;

  AuthLocalDataSourceImpl({
    this.validEmail = AppConstants.dummyEmail,
    this.validPassword = AppConstants.dummyPassword,
    this.userName = AppConstants.dummyUserName,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate brief network latency for realistic UX
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();
    final expectedEmail = validEmail.trim().toLowerCase();

    if (normalizedEmail == expectedEmail && password == validPassword) {
      return UserModel(
        id: 'user_001',
        name: userName,
        email: email.trim(),
      );
    } else {
      throw const AuthException(
        'Invalid email or password. Use demo credentials to sign in.',
      );
    }
  }
}
