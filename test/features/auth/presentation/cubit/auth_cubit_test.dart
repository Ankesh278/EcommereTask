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
  late AuthCubit cubit;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    cubit = AuthCubit(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tEmail = 'user@example.com';
  const tPassword = 'password123';
  const tUser = UserEntity(id: 'user_001', name: 'Alex Morgan', email: tEmail);

  test('initial state should be AuthInitial', () {
    expect(cubit.state, const AuthInitial());
  });

  group('Validation tests', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when email is empty and prevents login use case execution',
      build: () => cubit,
      act: (cubit) => cubit.login(email: '', password: tPassword),
      expect: () => [const AuthFailureState('Email is required')],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when email format is invalid',
      build: () => cubit,
      act: (cubit) => cubit.login(email: 'invalid-email', password: tPassword),
      expect: () => [
        const AuthFailureState('Please enter a valid email address'),
      ],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when password is empty',
      build: () => cubit,
      act: (cubit) => cubit.login(email: tEmail, password: ''),
      expect: () => [const AuthFailureState('Password is required')],
      verify: (_) {
        verifyZeroInteractions(mockLoginUseCase);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthFailureState] when password is shorter than 6 characters',
      build: () => cubit,
      act: (cubit) => cubit.login(email: tEmail, password: '123'),
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
          () => mockLoginUseCase(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => const Success(tUser));
        return cubit;
      },
      act: (cubit) => cubit.login(email: tEmail, password: tPassword),
      expect: () => [const AuthLoading(), const AuthSuccess(tUser)],
      verify: (_) {
        verify(
          () => mockLoginUseCase(email: tEmail, password: tPassword),
        ).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailureState] when usecase returns AuthFailure',
      build: () {
        when(
          () => mockLoginUseCase(email: tEmail, password: tPassword),
        ).thenAnswer(
          (_) async => const Error(AuthFailure('Invalid email or password.')),
        );
        return cubit;
      },
      act: (cubit) => cubit.login(email: tEmail, password: tPassword),
      expect: () => [
        const AuthLoading(),
        const AuthFailureState('Invalid email or password.'),
      ],
      verify: (_) {
        verify(
          () => mockLoginUseCase(email: tEmail, password: tPassword),
        ).called(1);
      },
    );

    test('reset() emits AuthInitial', () {
      cubit.emit(const AuthFailureState('Some error'));
      expect(cubit.state, const AuthFailureState('Some error'));
      cubit.reset();
      expect(cubit.state, const AuthInitial());
    });
  });
}
