import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_bottom_bar.dart';
import '../widgets/empty_cart_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _showClearCartConfirmationDialog(BuildContext context) {
    AppConfirmationDialog.show(
      context,
      icon: Icons.delete_sweep_outlined,
      title: 'Clear Shopping Cart?',
      message:
          'Are you sure you want to remove all items from your shopping cart?',
      confirmText: 'Clear All',
      cancelText: 'Cancel',
      isDestructive: true,
    ).then((isConfirmed) {
      if (isConfirmed == true && context.mounted) {
        context.read<CartCubit>().clearCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('My Cart'),
                if (cartState.isNotEmpty)
                  Text(
                    '${cartState.totalItemCount} ${cartState.totalItemCount == 1 ? 'item' : 'items'} (${cartState.distinctProductCount} unique)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            );
          },
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              if (cartState.isEmpty) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => _showClearCartConfirmationDialog(context),
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  size: 18,
                  color: AppColors.error,
                ),
                label: const Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (cartState.isEmpty) {
            return const EmptyCartView();
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: cartState.items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cartItem = cartState.items[index];
                  return CartItemCard(
                    key: ValueKey('cart_item_${cartItem.product.id}'),
                    item: cartItem,
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const CartSummaryBottomBar(),
    );
  }
}
