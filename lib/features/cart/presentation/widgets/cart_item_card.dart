import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../cubit/cart_cubit.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 72,
              height: 72,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Icon(
                    Icons.checkroom_rounded,
                    color: AppColors.textMuted,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Details and Quantity Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    // Trash / Remove button
                    InkWell(
                      key: Key('remove_${product.id}'),
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (onRemove != null) {
                          onRemove!();
                        } else {
                          context.read<CartCubit>().removeFromCart(product.id);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppConstants.currencySymbol}${product.price.toInt()} each',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Subtotal
                    Text(
                      '${AppConstants.currencySymbol}${item.totalPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // Quantity control buttons
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _QuantityButton(
                            key: Key('decrement_${product.id}'),
                            icon: item.quantity == 1
                                ? Icons.delete_outline
                                : Icons.remove,
                            color: item.quantity == 1
                                ? AppColors.error
                                : AppColors.textPrimary,
                            onPressed: () {
                              if (onDecrement != null) {
                                onDecrement!();
                              } else {
                                context
                                    .read<CartCubit>()
                                    .decreaseQuantity(product.id);
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '${item.quantity}',
                              key: Key('qty_${product.id}'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _QuantityButton(
                            key: Key('increment_${product.id}'),
                            icon: Icons.add,
                            color: AppColors.textPrimary,
                            onPressed: () {
                              if (onIncrement != null) {
                                onIncrement!();
                              } else {
                                context
                                    .read<CartCubit>()
                                    .increaseQuantity(product.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _QuantityButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
