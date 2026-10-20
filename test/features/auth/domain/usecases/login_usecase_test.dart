import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercetask/core/errors/failures.dart';
import 'package:ecommercetask/core/utils/result.dart';
import 'package:ecommercetask/features/auth/domain/entities/user_entity.dart';
import 'package:ecommercetask/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommercetask/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tEmail = 'user@example.com';
  const tPassword = 'password123';
  const tUser = UserEntity(
    id: 'user_001',
    name: 'Alex Morgan',
    email: tEmail,
  );

  test('should return UserEntity on successful login from repository', () async {
    // Arrange
    when(
      () => mockRepository.login(email: tEmail, password: tPassword),
    ).thenAnswer((_) async => const Success(tUser));

    // Act
    final result = await useCase(email: tEmail, password: tPassword);

    // Assert
    expect(result, const Success<UserEntity, Failure>(tUser));
    verify(() => mockRepository.login(email: tEmail, password: tPassword))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthFailure when repository login fails', () async {
    // Arrange
    const tFailure = AuthFailure('Invalid credentials');
    when(
      () => mockRepository.login(email: tEmail, password: tPassword),
    ).thenAnswer((_) async => const Error(tFailure));

    // Act
    final result = await useCase(email: tEmail, password: tPassword);

    // Assert
    expect(result, const Error<UserEntity, Failure>(tFailure));
    verify(() => mockRepository.login(email: tEmail, password: tPassword))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
