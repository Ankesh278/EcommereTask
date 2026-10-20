import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../widgets/cart_badge_icon.dart';
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
    final cubit = context.read<ProductCubit>();
    if (cubit.state is ProductInitial) {
      cubit.loadProducts();
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().reset();
              Navigator.pushReplacementNamed(context, AppConstants.routeLogin);
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
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
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const AppLoadingIndicator(
              message: 'Loading fashion catalog...',
            );
          }

          if (state is ProductError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<ProductCubit>().loadProducts(),
            );
          }

          if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
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
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
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
    );
  }
}
