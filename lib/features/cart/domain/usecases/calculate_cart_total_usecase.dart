import '../entities/cart_item_entity.dart';

class CalculateCartTotalUseCase {
  const CalculateCartTotalUseCase();

  double call(List<CartItemEntity> cartItemList) {
    return cartItemList.fold<double>(
      0.0,
      (runningTotal, currentCartItem) =>
          runningTotal + currentCartItem.totalPrice,
    );
  }

  int calculateTotalItems(List<CartItemEntity> cartItemList) {
    return cartItemList.fold<int>(
      0,
      (runningCount, currentCartItem) =>
          runningCount + currentCartItem.quantity,
    );
  }
}
