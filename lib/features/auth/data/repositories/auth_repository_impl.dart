import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<UserEntity, Failure>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await localDataSource.login(
        email: email,
        password: password,
      );
      return Success(userModel);
    } on AuthException catch (e) {
      return Error(AuthFailure(e.message));
    } catch (e) {
      return Error(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
