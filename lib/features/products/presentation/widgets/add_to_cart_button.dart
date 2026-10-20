import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../domain/entities/product_entity.dart';

enum AddToCartButtonVariant { compact, expanded,}
class AddToCartButton extends StatelessWidget {
  final ProductEntity product;
  final AddToCartButtonVariant variant;
  final VoidCallback? onPressed;
  final bool showFeedback;
  final Key? buttonKey;

  const AddToCartButton({
    super.key,
    required this.product,
    this.variant = AddToCartButtonVariant.compact,
    this.onPressed,
    this.showFeedback = true,
    this.buttonKey,
  });

  factory AddToCartButton.compact({
    Key? key,
    required ProductEntity product,
    VoidCallback? onPressed,
    bool showFeedback = true,
  }) {
    return AddToCartButton(
      product: product,
      variant: AddToCartButtonVariant.compact,
      onPressed: onPressed,
      showFeedback: showFeedback,
      buttonKey: key ?? Key('add_to_cart_${product.id}'),
    );
  }
  factory AddToCartButton.expanded({
    Key? key,
    required ProductEntity product,
    VoidCallback? onPressed,
    bool showFeedback = true,
  }) {
    return AddToCartButton(
      product: product,
      variant: AddToCartButtonVariant.expanded,
      onPressed: onPressed,
      showFeedback: showFeedback,
      buttonKey: key,
    );
  }

  void _handleAddToCartClick(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
    } else {
      context.read<CartCubit>().addToCart(product);
      if (showFeedback) {
        AppSnackBar.showSuccess(context, '${product.name} added to cart');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final int quantityInCart = context.read<CartCubit>().getProductQuantity(
          product.id,
        );

        if (variant == AddToCartButtonVariant.expanded) {
          return AppButton(
            key: buttonKey ?? key,
            text: quantityInCart > 0
                ? 'Add to Cart ($quantityInCart in cart)'
                : 'Add to Cart',
            icon: Icons.add_shopping_cart_rounded,
            onPressed: () => _handleAddToCartClick(context),
          );
        }

        return ElevatedButton(
          key: buttonKey ?? key ?? Key('add_to_cart_${product.id}'),
          onPressed: () => _handleAddToCartClick(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: quantityInCart > 0
                ? AppColors.accentDark
                : AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_shopping_cart, size: 14),
              const SizedBox(width: 4),
              Text(
                quantityInCart > 0 ? '($quantityInCart)' : 'Add',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
