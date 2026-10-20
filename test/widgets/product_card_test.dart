import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercetask/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';
import 'package:ecommercetask/features/products/presentation/widgets/product_card.dart';
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

  testWidgets(
    'ProductCard displays title, price, category, rating, and handles tap',
    (WidgetTester tester) async {
      bool isAddToCartTapped = false;
      final cartCubit = CartCubit();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CartCubit>.value(
              value: cartCubit,
              child: SizedBox(
                height: 350,
                width: 200,
                child: ProductCard(
                  product: sampleProduct,
                  onAddToCart: () {
                    isAddToCartTapped = true;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify UI items
      expect(find.text('Heritage Denim Jacket'), findsOneWidget);
      expect(find.text('₹${sampleProduct.price.toInt()}'), findsOneWidget);
      expect(find.text('Outerwear'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);

      // Tap Add to Cart
      final addButton = find.byKey(const Key('add_to_cart_prod_001'));
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pump();

      expect(isAddToCartTapped, isTrue);

      cartCubit.close();
    },
  );

  testWidgets('Tapping ProductCard body triggers onTap callback', (
    WidgetTester tester,
  ) async {
    bool isCardBodyTapped = false;

    final cartCubit = CartCubit();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CartCubit>.value(
            value: cartCubit,
            child: SizedBox(
              height: 350,
              width: 200,
              child: ProductCard(
                product: sampleProduct,
                onTap: () => isCardBodyTapped = true,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    // Tap on product title / card area
    await tester.tap(find.text('Heritage Denim Jacket'));
    await tester.pump();

    expect(isCardBodyTapped, isTrue);

    cartCubit.close();
  });
}
