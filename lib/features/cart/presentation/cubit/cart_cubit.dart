import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_state.dart';

/// Cubit managing all cart business operations across the application.
/// Uses clear, work-oriented method and variable names.
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  /// Adds a product to the cart. If the product is already in the cart,
  /// its quantity is incremented by 1, preventing duplicate entries.
  void addToCart(ProductEntity productToAdd) {
    final updatedCartItems = List<CartItemEntity>.from(state.items);
    final existingItemIndex = updatedCartItems.indexWhere(
      (cartItem) => cartItem.product.id == productToAdd.id,
    );

    if (existingItemIndex >= 0) {
      final existingCartItem = updatedCartItems[existingItemIndex];
      updatedCartItems[existingItemIndex] = existingCartItem.copyWith(
        quantity: existingCartItem.quantity + 1,
      );
    } else {
      updatedCartItems.add(CartItemEntity(product: productToAdd, quantity: 1));
    }

    emit(CartState(items: updatedCartItems));
  }

  /// Increments the quantity of an existing item in the cart.
  void increaseQuantity(String productId) {
    final updatedCartItems = List<CartItemEntity>.from(state.items);
    final existingItemIndex = updatedCartItems.indexWhere(
      (cartItem) => cartItem.product.id == productId,
    );

    if (existingItemIndex >= 0) {
      final existingCartItem = updatedCartItems[existingItemIndex];
      updatedCartItems[existingItemIndex] = existingCartItem.copyWith(
        quantity: existingCartItem.quantity + 1,
      );
      emit(CartState(items: updatedCartItems));
    }
  }

  /// Decrements the quantity of an existing item.
  /// If the quantity reaches 0 (decremented from 1), the item is
  /// automatically removed from the cart.
  void decreaseQuantity(String productId) {
    final updatedCartItems = List<CartItemEntity>.from(state.items);
    final existingItemIndex = updatedCartItems.indexWhere(
      (cartItem) => cartItem.product.id == productId,
    );

    if (existingItemIndex >= 0) {
      final existingCartItem = updatedCartItems[existingItemIndex];
      if (existingCartItem.quantity > 1) {
        updatedCartItems[existingItemIndex] = existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        );
      } else {
        // Automatically remove when quantity reaches zero
        updatedCartItems.removeAt(existingItemIndex);
      }
      emit(CartState(items: updatedCartItems));
    }
  }

  /// Removes an item completely from the cart regardless of its quantity.
  void removeFromCart(String productId) {
    final updatedCartItems = List<CartItemEntity>.from(state.items);
    updatedCartItems.removeWhere(
      (cartItem) => cartItem.product.id == productId,
    );
    emit(CartState(items: updatedCartItems));
  }

  /// Clears all items from the cart.
  void clearCart() {
    emit(const CartState(items: []));
  }

  /// Returns the current quantity of a specific product in the cart.
  int getProductQuantity(String productId) {
    for (final cartItem in state.items) {
      if (cartItem.product.id == productId) {
        return cartItem.quantity;
      }
    }
    return 0;
  }
}
