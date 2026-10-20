import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});
  int get distinctProductCount => items.length;
  int get totalItemCount => items.fold<int>(
    0,
    (cumulativeCount, cartItem) => cumulativeCount + cartItem.quantity,
  );

  double get totalPrice => items.fold<double>(
    0.0,
    (cumulativePrice, cartItem) => cumulativePrice + cartItem.totalPrice,
  );

  String get formattedTotalPrice => '₹${totalPrice.toInt()}';

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  CartState copyWith({List<CartItemEntity>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
