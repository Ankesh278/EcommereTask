import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final String primaryEmail;
  final String primaryPassword;
  final String primaryName;

  AuthLocalDataSourceImpl({
    this.primaryEmail = AppConstants.demoEmail,
    this.primaryPassword = AppConstants.demoPassword,
    this.primaryName = AppConstants.demoUserName,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail == primaryEmail.toLowerCase() &&
        password == primaryPassword) {
      return UserModel(id: 'user_demo', name: primaryName, email: email.trim());
    }

    if (normalizedEmail == AppConstants.dummyEmail.toLowerCase() &&
        password == AppConstants.dummyPassword) {
      return UserModel(
        id: 'user_001',
        name: AppConstants.dummyUserName,
        email: email.trim(),
      );
    }

    throw const AuthException(
      'Invalid email or password. Use demo credentials to sign in.',
    );
  }
}
