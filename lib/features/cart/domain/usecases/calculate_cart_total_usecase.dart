import '../entities/cart_item_entity.dart';

class CalculateCartTotalUseCase {
  const CalculateCartTotalUseCase();

  double call(List<CartItemEntity> items) {
    return items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  int calculateTotalItems(List<CartItemEntity> items) {
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}
