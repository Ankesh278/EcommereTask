import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});

  /// Total count of distinct products in the cart
  int get distinctProductCount => items.length;

  /// Total cumulative quantity of all items in the cart (for the cart badge)
  int get totalItemCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  /// Grand total price in INR
  double get totalPrice =>
      items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  /// Formatted total price in INR
  String get formattedTotalPrice => '₹${totalPrice.toInt()}';

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  CartState copyWith({
    List<CartItemEntity>? items,
  }) {
    return CartState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}
