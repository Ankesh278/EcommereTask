import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercetask/core/errors/failures.dart';
import 'package:ecommercetask/core/utils/result.dart';
import 'package:ecommercetask/features/auth/domain/entities/user_entity.dart';
import 'package:ecommercetask/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommercetask/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  const sampleEmail = 'user@example.com';
  const samplePassword = 'password123';
  const sampleUser = UserEntity(
    id: 'user_001',
    name: 'Alex Morgan',
    email: sampleEmail,
  );

  test(
    'should return UserEntity on successful login from repository',
    () async {
      // Arrange
      when(
        () => mockAuthRepository.login(
          email: sampleEmail,
          password: samplePassword,
        ),
      ).thenAnswer((_) async => const Success(sampleUser));

      // Act
      final loginResult = await loginUseCase(
        email: sampleEmail,
        password: samplePassword,
      );

      // Assert
      expect(loginResult, const Success<UserEntity, Failure>(sampleUser));
      verify(
        () => mockAuthRepository.login(
          email: sampleEmail,
          password: samplePassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test('should return AuthFailure when repository login fails', () async {
    // Arrange
    const sampleFailure = AuthFailure('Invalid credentials');
    when(
      () => mockAuthRepository.login(
        email: sampleEmail,
        password: samplePassword,
      ),
    ).thenAnswer((_) async => const Error(sampleFailure));

    // Act
    final loginResult = await loginUseCase(
      email: sampleEmail,
      password: samplePassword,
    );

    // Assert
    expect(loginResult, const Error<UserEntity, Failure>(sampleFailure));
    verify(
      () => mockAuthRepository.login(
        email: sampleEmail,
        password: samplePassword,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
