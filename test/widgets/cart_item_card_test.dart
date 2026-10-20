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

  const sampleProduct = ProductEntity(
    id: 'prod_001',
    name: 'Heritage Denim Jacket',
    description: 'Durable organic cotton denim.',
    price: 89.99,
    imageUrl: 'http://localhost/denim.jpg',
    category: 'Outerwear',
    rating: 4.8,
  );

  const sampleCartItem = CartItemEntity(product: sampleProduct, quantity: 2);

  testWidgets('CartItemCard renders details and triggers callbacks correctly', (
    WidgetTester tester,
  ) async {
    bool isIncrementCallbackCalled = false;
    bool isDecrementCallbackCalled = false;
    bool isRemoveCallbackCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartItemCard(
            item: sampleCartItem,
            onIncrement: () => isIncrementCallbackCalled = true,
            onDecrement: () => isDecrementCallbackCalled = true,
            onRemove: () => isRemoveCallbackCalled = true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify product name and pricing
    expect(find.text('Heritage Denim Jacket'), findsOneWidget);
    expect(find.text('₹${sampleProduct.price.toInt()} each'), findsOneWidget);
    expect(find.text('₹${sampleCartItem.totalPrice.toInt()}'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Test increment
    final incrementButton = find.byKey(const Key('increment_prod_001'));
    expect(incrementButton, findsOneWidget);
    await tester.tap(incrementButton);
    await tester.pump();
    expect(isIncrementCallbackCalled, isTrue);

    // Test decrement
    final decrementButton = find.byKey(const Key('decrement_prod_001'));
    expect(decrementButton, findsOneWidget);
    await tester.tap(decrementButton);
    await tester.pump();
    expect(isDecrementCallbackCalled, isTrue);

    // Test remove
    final removeButton = find.byKey(const Key('remove_prod_001'));
    expect(removeButton, findsOneWidget);
    await tester.tap(removeButton);
    await tester.pump();
    expect(isRemoveCallbackCalled, isTrue);
  });
}
