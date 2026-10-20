import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/product_network_image.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../cubit/cart_cubit.dart';
import 'quantity_selector.dart';

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
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
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
          //Product image
          ProductNetworkImage(
            imageUrl: product.imageUrl,
            width: AppDimensions.cartItemThumbnailSize,
            height: AppDimensions.cartItemThumbnailSize,
            borderRadius: BorderRadius.circular(10),
            placeholderCategory: product.category,
          ),
          const SizedBox(width: 14),

          // Details
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
                    //Remove button
                    InkWell(
                      key: Key('remove_${product.id}'),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
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
                PriceText.small(price: product.price, suffix: 'each'),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //total
                    PriceText(
                      price: item.totalPrice,
                      size: PriceTextSize.medium,
                    ),

                    //counter
                    QuantitySelector(
                      productId: product.id,
                      quantity: item.quantity,
                      onDecrement: () {
                        if (onDecrement != null) {
                          onDecrement!();
                        } else {
                          context.read<CartCubit>().decreaseQuantity(
                            product.id,
                          );
                        }
                      },
                      onIncrement: () {
                        if (onIncrement != null) {
                          onIncrement!();
                        } else {
                          context.read<CartCubit>().increaseQuantity(
                            product.id,
                          );
                        }
                      },
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
