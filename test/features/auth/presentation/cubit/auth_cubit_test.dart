import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercetask/core/errors/failures.dart';
import 'package:ecommercetask/core/utils/result.dart';
import 'package:ecommercetask/features/auth/domain/entities/user_entity.dart';
import 'package:ecommercetask/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommercetask/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommercetask/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late AuthCubit authCubit;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authCubit = AuthCubit(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    authCubit.close();
  });

  const sampleEmail = 'user@example.com';
  const samplePassword = 'password123';
  const sampleUser = UserEntity(
    id: 'user_001',
    name: 'Alex Morgan',
    email: sampleEmail,
  );

  test('initial state should be AuthInitial', () {
    expect(authCubit.state, const AuthInitial());
  });

  group('Validation tests', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when email is empty and prevents login use case execution',
      build: () => authCubit,
      act: (cubit) => cubit.login(email: '', password: samplePassword),
      expect: () => [const AuthFailureState('Email is required')],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when email format is invalid',
      build: () => authCubit,
      act: (cubit) =>
          cubit.login(email: 'invalid-email', password: samplePassword),
      expect: () => [
        const AuthFailureState('Please enter a valid email address'),
      ],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when password is empty',
      build: () => authCubit,
      act: (cubit) => cubit.login(email: sampleEmail, password: ''),
      expect: () => [const AuthFailureState('Password is required')],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when password is shorter than 6 characters',
      build: () => authCubit,
      act: (cubit) => cubit.login(email: sampleEmail, password: '123'),
      expect: () => [
        const AuthFailureState('Password must be at least 6 characters'),
      ],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );
  });

  group('Authentication state transitions', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] on valid credentials',
      build: () {
        when(
          () => mockLoginUseCase(email: sampleEmail, password: samplePassword),
        ).thenAnswer((_) async => const Success(sampleUser));
        return authCubit;
      },
      act: (cubit) => cubit.login(email: sampleEmail, password: samplePassword),
      expect: () => [const AuthLoading(), const AuthSuccess(sampleUser)],
      verify: (_) {
        verify(
          () => mockLoginUseCase(email: sampleEmail, password: samplePassword),
        ).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailureState] when usecase returns AuthFailure',
      build: () {
        when(
          () => mockLoginUseCase(email: sampleEmail, password: samplePassword),
        ).thenAnswer(
          (_) async => const Error(AuthFailure('Invalid email or password.')),
        );
        return authCubit;
      },
      act: (cubit) => cubit.login(email: sampleEmail, password: samplePassword),
      expect: () => [
        const AuthLoading(),
        const AuthFailureState('Invalid email or password.'),
      ],
      verify: (_) {
        verify(
          () => mockLoginUseCase(email: sampleEmail, password: samplePassword),
        ).called(1);
      },
    );

    test('reset() emits AuthInitial', () {
      authCubit.emit(const AuthFailureState('Some error'));
      expect(authCubit.state, const AuthFailureState('Some error'));
      authCubit.reset();
      expect(authCubit.state, const AuthInitial());
    });
  });
}
