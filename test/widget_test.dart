import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercetask/app.dart';
import 'package:ecommercetask/core/constants/app_constants.dart';
import 'package:ecommercetask/injection_container.dart' as di;
import 'test_helper.dart';

void main() {
  setUpAll(() async {
    HttpOverrides.global = TestHttpOverrides();
    await di.initDependencies();
  });

  testWidgets('Full End-to-End User Flow: Login -> Products -> Cart -> Navigation',
      (WidgetTester tester) async {
    // 1. Launch App
    await tester.pumpWidget(const EcommerceApp());
    await tester.pump();

    // 2. Verify Login Screen elements
    expect(find.text(AppConstants.appTitle), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // 3. Auto-fill demo credentials
    final autoFillBtn = find.text('Auto Fill');
    expect(autoFillBtn, findsOneWidget);
    await tester.tap(autoFillBtn);
    await tester.pump();

    // 4. Tap Sign In
    final signInBtn = find.text('Sign In');
    await tester.tap(signInBtn);

    // Pump past the 500ms mock delay for login
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    // Pump past the 350ms mock delay for loading products
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    // 5. Verify Navigation to Product Listing Screen
    expect(find.text('Exclusive Collection'), findsOneWidget);
    expect(find.byTooltip('Shopping Cart'), findsOneWidget);

    // 6. Add first product to cart
    final addButtons = find.text('Add');
    expect(addButtons, findsWidgets);
    await tester.tap(addButtons.first);
    await tester.pump();

    // Verify badge updated to 1
    expect(find.text('1'), findsOneWidget);

    // 7. Open Cart Screen
    final cartIcon = find.byTooltip('Shopping Cart');
    await tester.tap(cartIcon);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    // Verify Cart Screen content
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('Total Cart Amount'), findsOneWidget);
    expect(find.text('Proceed to Checkout'), findsOneWidget);

    // 8. Return to Products Screen
    final backBtn = find.byType(BackButton);
    if (backBtn.evaluate().isNotEmpty) {
      await tester.tap(backBtn);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
    } else {
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
    }

    // Verify Cart state was preserved (badge still shows 1)
    expect(find.text('1'), findsOneWidget);
  });
}
