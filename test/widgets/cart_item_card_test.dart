import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercetask/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommercetask/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  const tProduct = ProductEntity(
    id: 'prod_001',
    name: 'Heritage Denim Jacket',
    description: 'Durable organic cotton denim.',
    price: 89.99,
    imageUrl: 'http://localhost/denim.jpg',
    category: 'Outerwear',
    rating: 4.8,
  );

  const tCartItem = CartItemEntity(
    product: tProduct,
    quantity: 2,
  );

  testWidgets('CartItemCard renders details and triggers callbacks correctly',
      (WidgetTester tester) async {
    bool incrementCalled = false;
    bool decrementCalled = false;
    bool removeCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartItemCard(
            item: tCartItem,
            onIncrement: () => incrementCalled = true,
            onDecrement: () => decrementCalled = true,
            onRemove: () => removeCalled = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify product name and pricing
    expect(find.text('Heritage Denim Jacket'), findsOneWidget);
    expect(find.text('\$89.99 each'), findsOneWidget);
    expect(find.text('\$179.98'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Test increment
    final incButton = find.byKey(const Key('increment_prod_001'));
    expect(incButton, findsOneWidget);
    await tester.tap(incButton);
    await tester.pump();
    expect(incrementCalled, isTrue);

    // Test decrement
    final decButton = find.byKey(const Key('decrement_prod_001'));
    expect(decButton, findsOneWidget);
    await tester.tap(decButton);
    await tester.pump();
    expect(decrementCalled, isTrue);

    // Test remove
    final removeButton = find.byKey(const Key('remove_prod_001'));
    expect(removeButton, findsOneWidget);
    await tester.tap(removeButton);
    await tester.pump();
    expect(removeCalled, isTrue);
  });
}
