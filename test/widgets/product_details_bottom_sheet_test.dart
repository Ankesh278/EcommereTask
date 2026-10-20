import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercetask/core/constants/app_constants.dart';
import 'package:ecommercetask/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';
import 'package:ecommercetask/features/products/presentation/widgets/product_details_bottom_sheet.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  const tProduct = ProductEntity(
    id: 'prod_001',
    name: 'Classic Cotton T-Shirt',
    description:
        '100% combed cotton crewneck t-shirt with durable double stitching.',
    price: 799.0,
    imageUrl: 'http://localhost/tshirt.jpg',
    category: 'T-Shirts',
    rating: 4.7,
  );

  testWidgets(
    'ProductDetailsBottomSheet renders product details and triggers Add to Cart',
    (WidgetTester tester) async {
      final cartCubit = CartCubit();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CartCubit>.value(
              value: cartCubit,
              child: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () =>
                      ProductDetailsBottomSheet.show(context, tProduct),
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Verify sheet contents
      expect(find.text('Classic Cotton T-Shirt'), findsOneWidget);
      expect(find.text('T-SHIRTS'), findsOneWidget);
      expect(
        find.text('${AppConstants.currencySymbol}${tProduct.price.toInt()}'),
        findsOneWidget,
      );
      expect(find.text(tProduct.description), findsOneWidget);
      expect(find.text('4.7'), findsOneWidget);

      // Verify Add to Cart button in sheet
      final addToCartBtn = find.widgetWithText(ElevatedButton, 'Add to Cart');
      expect(addToCartBtn, findsOneWidget);

      // Tap Add to Cart in bottom sheet
      await tester.tap(addToCartBtn);
      await tester.pump();

      // Verify item was added to CartCubit
      expect(cartCubit.state.totalItemCount, 1);
      expect(cartCubit.state.items.first.product.id, 'prod_001');

      cartCubit.close();
    },
  );
}
