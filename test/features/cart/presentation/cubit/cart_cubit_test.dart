import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercetask/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommercetask/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommercetask/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';

void main() {
  late CartCubit cartCubit;

  setUp(() {
    cartCubit = CartCubit();
  });

  tearDown(() {
    cartCubit.close();
  });

  const tProductA = ProductEntity(
    id: 'prod_001',
    name: 'Denim Jacket',
    description: 'Classic denim jacket',
    price: 80.0,
    imageUrl: 'https://example.com/denim.jpg',
    category: 'Outerwear',
    rating: 4.8,
  );

  const tProductB = ProductEntity(
    id: 'prod_002',
    name: 'Cotton T-Shirt',
    description: 'Casual t-shirt',
    price: 30.0,
    imageUrl: 'https://example.com/tshirt.jpg',
    category: 'Tops',
    rating: 4.5,
  );

  group('CartCubit initialization and empty state', () {
    test('initial state has empty items list, 0 total count, and 0.0 total price', () {
      expect(cartCubit.state, const CartState());
      expect(cartCubit.state.items, isEmpty);
      expect(cartCubit.state.totalItemCount, 0);
      expect(cartCubit.state.totalPrice, 0.0);
      expect(cartCubit.state.isEmpty, isTrue);
      expect(cartCubit.state.isNotEmpty, isFalse);
    });
  });

  group('Cart operations: add to cart', () {
    blocTest<CartCubit, CartState>(
      'adds a new product with initial quantity of 1',
      build: () => cartCubit,
      act: (cubit) => cubit.addToCart(tProductA),
      expect: () => [
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 1),
          ],
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.totalItemCount, 1);
        expect(cubit.state.totalPrice, 80.0);
        expect(cubit.state.isEmpty, isFalse);
      },
    );

    blocTest<CartCubit, CartState>(
      'prevents duplicate entries when adding same product again by incrementing quantity',
      build: () => cartCubit,
      act: (cubit) {
        cubit.addToCart(tProductA);
        cubit.addToCart(tProductA);
      },
      expect: () => [
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 1),
          ],
        ),
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 2),
          ],
        ),
      ],
      verify: (cubit) {
        // Only 1 unique item in items list
        expect(cubit.state.items.length, 1);
        expect(cubit.state.items.first.quantity, 2);
        expect(cubit.state.totalItemCount, 2);
        expect(cubit.state.totalPrice, 160.0);
      },
    );

    blocTest<CartCubit, CartState>(
      'adds multiple distinct products and calculates cumulative badge count and total price',
      build: () => cartCubit,
      act: (cubit) {
        cubit.addToCart(tProductA);
        cubit.addToCart(tProductB);
      },
      expect: () => [
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 1),
          ],
        ),
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 1),
            CartItemEntity(product: tProductB, quantity: 1),
          ],
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.items.length, 2);
        expect(cubit.state.totalItemCount, 2);
        expect(cubit.state.totalPrice, 110.0);
      },
    );
  });

  group('Quantity changes', () {
    blocTest<CartCubit, CartState>(
      'increaseQuantity increments item quantity and updates total price',
      build: () => cartCubit,
      seed: () => const CartState(
        items: [
          CartItemEntity(product: tProductA, quantity: 1),
        ],
      ),
      act: (cubit) => cubit.increaseQuantity(tProductA.id),
      expect: () => [
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 2),
          ],
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.totalItemCount, 2);
        expect(cubit.state.totalPrice, 160.0);
      },
    );

    blocTest<CartCubit, CartState>(
      'decreaseQuantity decrements quantity when quantity > 1',
      build: () => cartCubit,
      seed: () => const CartState(
        items: [
          CartItemEntity(product: tProductA, quantity: 3),
        ],
      ),
      act: (cubit) => cubit.decreaseQuantity(tProductA.id),
      expect: () => [
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 2),
          ],
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.totalItemCount, 2);
        expect(cubit.state.totalPrice, 160.0);
      },
    );

    blocTest<CartCubit, CartState>(
      'decreaseQuantity automatically removes item when quantity reaches zero (from 1)',
      build: () => cartCubit,
      seed: () => const CartState(
        items: [
          CartItemEntity(product: tProductA, quantity: 1),
        ],
      ),
      act: (cubit) => cubit.decreaseQuantity(tProductA.id),
      expect: () => [
        const CartState(items: []),
      ],
      verify: (cubit) {
        expect(cubit.state.items, isEmpty);
        expect(cubit.state.totalItemCount, 0);
        expect(cubit.state.totalPrice, 0.0);
        expect(cubit.state.isEmpty, isTrue);
      },
    );
  });

  group('Cart removal and clearing', () {
    blocTest<CartCubit, CartState>(
      'removeFromCart removes item regardless of its quantity',
      build: () => cartCubit,
      seed: () => const CartState(
        items: [
          CartItemEntity(product: tProductA, quantity: 5),
          CartItemEntity(product: tProductB, quantity: 2),
        ],
      ),
      act: (cubit) => cubit.removeFromCart(tProductA.id),
      expect: () => [
        const CartState(
          items: [
            CartItemEntity(product: tProductB, quantity: 2),
          ],
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.items.length, 1);
        expect(cubit.state.totalItemCount, 2);
        expect(cubit.state.totalPrice, 60.0);
      },
    );

    blocTest<CartCubit, CartState>(
      'clearCart empties the entire cart',
      build: () => cartCubit,
      seed: () => const CartState(
        items: [
          CartItemEntity(product: tProductA, quantity: 2),
          CartItemEntity(product: tProductB, quantity: 3),
        ],
      ),
      act: (cubit) => cubit.clearCart(),
      expect: () => [
        const CartState(items: []),
      ],
      verify: (cubit) {
        expect(cubit.state.isEmpty, isTrue);
        expect(cubit.state.totalItemCount, 0);
        expect(cubit.state.totalPrice, 0.0);
      },
    );

    test('getProductQuantity returns accurate count or 0 if absent', () {
      cartCubit.emit(
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 3),
          ],
        ),
      );

      expect(cartCubit.getProductQuantity(tProductA.id), 3);
      expect(cartCubit.getProductQuantity('non_existent_id'), 0);
    });

    test('distinctProductCount and totalItemCount are clearly distinguished', () {
      cartCubit.emit(
        const CartState(
          items: [
            CartItemEntity(product: tProductA, quantity: 3),
            CartItemEntity(product: tProductB, quantity: 2),
          ],
        ),
      );

      expect(cartCubit.state.distinctProductCount, 2);
      expect(cartCubit.state.totalItemCount, 5);
      expect(cartCubit.state.totalPrice, (80.0 * 3) + (30.0 * 2));
      expect(cartCubit.state.formattedTotalPrice, '₹300');
    });

    test('state is immutable and collections are not mutated in place', () {
      final initialList = [
        const CartItemEntity(product: tProductA, quantity: 1),
      ];
      cartCubit.emit(CartState(items: initialList));

      cartCubit.increaseQuantity(tProductA.id);

      // Verify that initialList was not modified in-place
      expect(initialList.first.quantity, 1);
      // New state has updated copy
      expect(cartCubit.state.items.first.quantity, 2);
    });
  });
}
