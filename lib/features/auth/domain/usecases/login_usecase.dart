import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Result<UserEntity, Failure>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
