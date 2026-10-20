import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercetask/core/widgets/app_button.dart';
import 'package:ecommercetask/core/widgets/app_confirmation_dialog.dart';
import 'package:ecommercetask/core/widgets/app_text_field.dart';
import 'package:ecommercetask/core/widgets/price_text.dart';
import 'package:ecommercetask/core/widgets/product_network_image.dart';
import 'package:ecommercetask/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommercetask/features/cart/presentation/widgets/quantity_selector.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';
import 'package:ecommercetask/features/products/presentation/widgets/add_to_cart_button.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  const sampleTestProduct = ProductEntity(
    id: 'prod_test_001',
    name: 'Silk Blend Shirt',
    description: 'Premium tailored silk shirt.',
    price: 1499.0,
    imageUrl: 'http://localhost/shirt.jpg',
    category: 'Shirts',
    rating: 4.9,
  );

  group('AppButton Reusable Component Tests', () {
    testWidgets(
      'renders primary button, executes onPressed, and handles loading',
      (WidgetTester tester) async {
        bool isButtonPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Submit Order',
                icon: Icons.check,
                onPressed: () => isButtonPressed = true,
              ),
            ),
          ),
        );

        expect(find.text('Submit Order'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);

        await tester.tap(find.text('Submit Order'));
        await tester.pump();
        expect(isButtonPressed, isTrue);

        // Test loading state
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Submit Order',
                isLoading: true,
                onPressed: () => isButtonPressed = true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Submit Order'), findsNothing);
      },
    );

    testWidgets('renders outlined, compact, and danger factory variants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppButton.outlined(text: 'Cancel Action', onPressed: () {}),
                AppButton.compact(text: 'Quick Add', onPressed: () {}),
                AppButton.danger(text: 'Delete Item', onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Cancel Action'), findsOneWidget);
      expect(find.text('Quick Add'), findsOneWidget);
      expect(find.text('Delete Item'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });
  });

  group('AppTextField Reusable Component Tests', () {
    testWidgets(
      'renders label, asterisk when required, prefix, and handles input',
      (WidgetTester tester) async {
        String enteredPhoneNumber = '';
        final textEditingController = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppTextField(
                controller: textEditingController,
                labelText: 'Phone Number',
                hintText: 'Enter phone',
                isRequired: true,
                prefixIcon: Icons.phone,
                onChanged: (enteredText) => enteredPhoneNumber = enteredText,
              ),
            ),
          ),
        );

        expect(find.text('Phone Number'), findsOneWidget);
        expect(find.text('*'), findsOneWidget);
        expect(find.text('Enter phone'), findsOneWidget);
        expect(find.byIcon(Icons.phone), findsOneWidget);

        await tester.enterText(find.byType(TextFormField), '9876543210');
        expect(enteredPhoneNumber, '9876543210');
        expect(textEditingController.text, '9876543210');
      },
    );
  });

  group('AddToCartButton Reusable Component Tests', () {
    testWidgets(
      'compact variant adds product to cart and updates count badge',
      (WidgetTester tester) async {
        final cartCubit = CartCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider<CartCubit>.value(
                value: cartCubit,
                child: AddToCartButton.compact(product: sampleTestProduct),
              ),
            ),
          ),
        );

        // Initially shows 'Add'
        expect(find.text('Add'), findsOneWidget);

        // Tap to add to cart
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(cartCubit.state.totalItemCount, 1);
        // Now shows '(1)'
        expect(find.text('(1)'), findsOneWidget);

        cartCubit.close();
      },
    );

    testWidgets('expanded variant renders full width CTA with in-cart count', (
      WidgetTester tester,
    ) async {
      final cartCubit = CartCubit();
      cartCubit.addToCart(sampleTestProduct);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CartCubit>.value(
              value: cartCubit,
              child: AddToCartButton.expanded(product: sampleTestProduct),
            ),
          ),
        ),
      );

      expect(find.text('Add to Cart (1 in cart)'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart_rounded), findsOneWidget);

      cartCubit.close();
    });
  });

  group('QuantitySelector Reusable Component Tests', () {
    testWidgets(
      'shows delete icon at quantity 1 and remove/increment actions',
      (WidgetTester tester) async {
        bool isIncrementCallbackCalled = false;
        bool isDecrementCallbackCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: QuantitySelector(
                quantity: 1,
                productId: 'test_product_1',
                onIncrement: () => isIncrementCallbackCalled = true,
                onDecrement: () => isDecrementCallbackCalled = true,
              ),
            ),
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(find.byIcon(Icons.add));
        expect(isIncrementCallbackCalled, isTrue);

        await tester.tap(find.byIcon(Icons.delete_outline));
        expect(isDecrementCallbackCalled, isTrue);
      },
    );

    testWidgets('shows remove icon at quantity > 1', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantitySelector(
              quantity: 3,
              productId: 'test_product_2',
              onIncrement: () {},
              onDecrement: () {},
            ),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });

  group('PriceText Reusable Component Tests', () {
    testWidgets('formats currency and suffix appropriately', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const PriceText(price: 999),
                PriceText.small(price: 499, suffix: 'each'),
                PriceText.large(price: 2499),
                PriceText.total(price: 3998),
              ],
            ),
          ),
        ),
      );

      expect(find.text('₹999'), findsOneWidget);
      expect(find.text('₹499 each'), findsOneWidget);
      expect(find.text('₹2499'), findsOneWidget);
      expect(find.text('₹3998'), findsOneWidget);
    });
  });

  group('ProductNetworkImage Reusable Component Tests', () {
    testWidgets(
      'renders network image with placeholder icon when offline/mocked',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ProductNetworkImage(
                imageUrl: 'http://localhost/dummy.jpg',
                width: 100,
                height: 100,
                placeholderCategory: 'Apparel',
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.byType(Image), findsOneWidget);
      },
    );
  });

  group('AppConfirmationDialog Reusable Component Tests', () {
    testWidgets(
      'renders dialog and triggers onConfirm and onCancel callbacks',
      (WidgetTester tester) async {
        bool isDialogConfirmed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () =>
                      AppConfirmationDialog.show(
                        context,
                        icon: Icons.delete,
                        title: 'Delete Order',
                        message: 'Are you sure you want to delete this order?',
                        confirmText: 'Delete',
                        isDestructive: true,
                      ).then((userConfirmationResult) {
                        if (userConfirmationResult == true) {
                          isDialogConfirmed = true;
                        }
                      }),
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Delete Order'), findsOneWidget);
        expect(
          find.text('Are you sure you want to delete this order?'),
          findsOneWidget,
        );
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        expect(isDialogConfirmed, isTrue);
      },
    );
  });
}
