import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercetask/core/constants/app_constants.dart';
import 'package:ecommercetask/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommercetask/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommercetask/features/auth/presentation/pages/login_page.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late AuthCubit authCubit;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authCubit = AuthCubit(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    authCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('LoginPage renders all elements including demo credentials',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appTitle), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Demo Credentials'), findsOneWidget);
  });

  testWidgets('LoginPage shows validation error when submitting empty fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap Sign In button without entering text
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Verify validation errors are shown
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('LoginPage Auto Fill pre-fills email and password',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap Auto Fill
    await tester.tap(find.text('Auto Fill'));
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.dummyEmail), findsOneWidget);
    expect(find.text(AppConstants.dummyPassword), findsOneWidget);
  });
}
