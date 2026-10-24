import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_view.dart';
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
import '../widgets/product_search_bar.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({super.key});

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final productCubit = context.read<ProductCubit>();
    if (productCubit.state is ProductInitial) {
      productCubit.loadProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    AppConstants.appTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Exclusive Collection',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
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
      body: Column(
        children: [
          // Search Bar Area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: ProductSearchBar(
              hintText: 'Search products by title, brand...',
              onSearch: (query) {
                context.read<ProductCubit>().searchProducts(query);
              },
              onClear: () {
                context.read<ProductCubit>().clearSearch();
              },
            ),
          ),

          // Main Content
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, productState) {
                if (productState is ProductLoading) {
                  return AppLoadingIndicator(
                    message: productState.message ?? 'Loading fashion catalog...',
                  );
                }

                if (productState is ProductError) {
                  IconData errorIcon = Icons.error_outline_rounded;
                  if (productState.failure is NetworkFailure) {
                    errorIcon = Icons.wifi_off_rounded;
                  } else if (productState.failure is TimeoutFailure) {
                    errorIcon = Icons.timer_off_outlined;
                  } else if (productState.failure is ServerFailure) {
                    errorIcon = Icons.cloud_off_rounded;
                  }

                  return AppErrorView(
                    message: productState.message,
                    icon: errorIcon,
                    onRetry: () => context.read<ProductCubit>().loadProducts(),
                  );
                }

                if (productState is ProductLoaded) {
                  final productList = productState.products;

                  if (productList.isEmpty) {
                    if (productState.searchQuery.isNotEmpty) {
                      return EmptyStateView(
                        icon: Icons.search_off_rounded,
                        title: 'No Products Found',
                        message:
                            'No items matched "${productState.searchQuery}". Try different keywords or check spelling.',
                        actionText: 'Clear Search',
                        actionIcon: Icons.refresh_rounded,
                        onAction: () {
                          context.read<ProductCubit>().clearSearch();
                        },
                      );
                    }
                    return EmptyStateView(
                      icon: Icons.inventory_2_outlined,
                      title: 'Catalog Empty',
                      message: 'No products are currently available in the catalog.',
                      actionText: 'Refresh Catalog',
                      actionIcon: Icons.refresh_rounded,
                      onAction: () => context.read<ProductCubit>().loadProducts(),
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
                          await context.read<ProductCubit>().refreshProducts();
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
          ),
        ],
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
