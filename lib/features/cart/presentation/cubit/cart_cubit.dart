import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  /// Adds a product to the cart. If the product is already in the cart,
  /// its quantity is incremented by 1, preventing duplicate entries.
  void addToCart(ProductEntity product) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      final existingItem = currentItems[index];
      currentItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      currentItems.add(CartItemEntity(product: product, quantity: 1));
    }

    emit(CartState(items: currentItems));
  }

  /// Increments the quantity of an existing item in the cart.
  void increaseQuantity(String productId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      final existingItem = currentItems[index];
      currentItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
      emit(CartState(items: currentItems));
    }
  }

  /// Decrements the quantity of an existing item.
  /// If the quantity reaches 0 (decremented from 1), the item is
  /// automatically removed from the cart as per design specification.
  void decreaseQuantity(String productId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      final existingItem = currentItems[index];
      if (existingItem.quantity > 1) {
        currentItems[index] = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
      } else {
        // Automatically remove when quantity drops to 0
        currentItems.removeAt(index);
      }
      emit(CartState(items: currentItems));
    }
  }

  /// Removes an item completely from the cart regardless of its quantity.
  void removeFromCart(String productId) {
    final currentItems = List<CartItemEntity>.from(state.items);
    currentItems.removeWhere((item) => item.product.id == productId);
    emit(CartState(items: currentItems));
  }

  /// Clears all items from the cart.
  void clearCart() {
    emit(const CartState(items: []));
  }

  /// Returns the current quantity of a specific product in the cart.
  int getProductQuantity(String productId) {
    for (final item in state.items) {
      if (item.product.id == productId) {
        return item.quantity;
      }
    }
    return 0;
  }
}
