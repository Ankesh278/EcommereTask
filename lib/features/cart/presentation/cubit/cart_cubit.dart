import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());
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
        updatedCartItems.removeAt(existingItemIndex);
      }
      emit(CartState(items: updatedCartItems));
    }
  }

  void removeFromCart(String productId) {
    final updatedCartItems = List<CartItemEntity>.from(state.items);
    updatedCartItems.removeWhere(
      (cartItem) => cartItem.product.id == productId,
    );
    emit(CartState(items: updatedCartItems));
  }

  void clearCart() {
    emit(const CartState(items: []));
  }

  int getProductQuantity(String productId) {
    for (final cartItem in state.items) {
      if (cartItem.product.id == productId) {
        return cartItem.quantity;
      }
    }
    return 0;
  }
}
