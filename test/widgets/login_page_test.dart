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

  testWidgets(
    'LoginPage renders all elements including demo credentials card',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(AppConstants.appTitle), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Demo Credentials'), findsOneWidget);
    },
  );

  testWidgets('LoginPage Sign In button is disabled when fields are empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Sign In');
    expect(tester.widget<ElevatedButton>(buttonFinder).enabled, isFalse);
  });

  testWidgets(
    'LoginPage shows inline validation error for invalid email and keeps button disabled',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Sign In');
      expect(tester.widget<ElevatedButton>(buttonFinder).enabled, isFalse);
    },
  );

  testWidgets(
    'LoginPage Auto Fill pre-fills demo credentials and enables Sign In button',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Auto Fill
      await tester.tap(find.text('Auto Fill'));
      await tester.pumpAndSettle();

      expect(find.text(AppConstants.demoEmail), findsOneWidget);
      expect(find.text(AppConstants.demoPassword), findsOneWidget);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Sign In');
      expect(tester.widget<ElevatedButton>(buttonFinder).enabled, isTrue);
    },
  );

  testWidgets('LoginPage toggles password visibility icon and obfuscation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Password is hidden by default, so eye icon is initially visibility_off_outlined
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();

    // Toggled to visibility_outlined
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });
}
