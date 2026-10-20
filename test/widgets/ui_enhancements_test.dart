import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercetask/core/widgets/logout_confirmation_dialog.dart';
import 'package:ecommercetask/features/products/presentation/widgets/floating_cart_button.dart';

void main() {
  group('FloatingCartButton widget test', () {
    testWidgets('renders item count, price, and responds to tap', (
      WidgetTester tester,
    ) async {
      bool isFloatingCartButtonTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FloatingCartButton(
              itemCount: 3,
              totalPrice: '₹2,499',
              onPressed: () => isFloatingCartButtonTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('View Cart'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('₹2,499'), findsOneWidget);
      expect(find.byKey(const Key('floating_cart_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('floating_cart_button')));
      await tester.pump();

      expect(isFloatingCartButtonTapped, isTrue);
    });
  });

  group('LogoutConfirmationDialog widget test', () {
    testWidgets('renders title, message, and executes onConfirm on Log Out tap', (
      WidgetTester tester,
    ) async {
      bool isLogoutConfirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => LogoutConfirmationDialog.show(
                  context,
                  onConfirm: () => isLogoutConfirmed = true,
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Log out?'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to log out of your account? You will be returned to the sign-in screen.',
        ),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Log Out'), findsOneWidget);

      // Tap Log Out
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle();

      expect(isLogoutConfirmed, isTrue);
    });

    testWidgets('Cancel button dismisses dialog without confirming', (
      WidgetTester tester,
    ) async {
      bool isLogoutConfirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => LogoutConfirmationDialog.show(
                  context,
                  onConfirm: () => isLogoutConfirmed = true,
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(isLogoutConfirmed, isFalse);
      expect(find.text('Log out?'), findsNothing);
    });
  });
}
