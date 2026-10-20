import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/logout_confirmation_dialog.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../widgets/cart_badge_icon.dart';
import '../widgets/floating_cart_button.dart';
import '../widgets/product_card.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({super.key});

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  @override
  void initState() {
    super.initState();
    final productCubit = context.read<ProductCubit>();
    if (productCubit.state is ProductInitial) {
      productCubit.loadProducts();
    }
  }

  void _showLogoutConfirmationDialog() {
    LogoutConfirmationDialog.show(
      context,
      onConfirm: () {
        context.read<AuthCubit>().reset();
        Navigator.pushReplacementNamed(context, AppConstants.routeLogin);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.checkroom_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppConstants.appTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Exclusive Collection',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const CartBadgeIcon(),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: _showLogoutConfirmationDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, productState) {
          if (productState is ProductLoading) {
            return const AppLoadingIndicator(
              message: 'Loading fashion catalog...',
            );
          }

          if (productState is ProductError) {
            return AppErrorView(
              message: productState.message,
              onRetry: () => context.read<ProductCubit>().loadProducts(),
            );
          }

          if (productState is ProductLoaded) {
            final productList = productState.products;

            if (productList.isEmpty) {
              return const Center(
                child: Text('No products available at the moment.'),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2;
                if (constraints.maxWidth > 900) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await context.read<ProductCubit>().loadProducts();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      final product = productList[index];
                      return ProductCard(
                        key: ValueKey('product_${product.id}'),
                        product: product,
                      );
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          final isCartNotEmpty = cartState.isNotEmpty;

          return AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            offset: isCartNotEmpty ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              opacity: isCartNotEmpty ? 1.0 : 0.0,
              child: isCartNotEmpty
                  ? FloatingCartButton(
                      itemCount: cartState.totalItemCount,
                      totalPrice: cartState.formattedTotalPrice,
                      onPressed: () {
                        Navigator.pushNamed(context, AppConstants.routeCart);
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
