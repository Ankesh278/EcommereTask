import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/product_network_image.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/cart_badge_icon.dart';



class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int _selectedImageIndex = 0;
  late final PageController _imagePageController;
  late final AnimationController _stirController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
    _stirController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 50,
      ),
    ]).animate(_stirController);

    _wiggleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -0.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.15, end: 0.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.15, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_stirController);
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _stirController.dispose();
    super.dispose();
  }

  List<String> get _displayImages {
    if (widget.product.images.isNotEmpty) {
      return widget.product.images;
    }
    if (widget.product.imageUrl.isNotEmpty) {
      return [widget.product.imageUrl];
    }
    return [];
  }

  void _incrementQuantity() {
    context.read<CartCubit>().increaseQuantity(widget.product.id);
    _stirController.forward(from: 0.0);
  }

  void _decrementQuantity() {
    context.read<CartCubit>().decreaseQuantity(widget.product.id);
    _stirController.forward(from: 0.0);
  }

  void _addToCart() {
    context.read<CartCubit>().addToCart(widget.product);
    _stirController.forward(from: 0.0);
  }



  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = _displayImages;
    final hasDiscount = product.discountPercentage > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          product.category.isNotEmpty
              ? product.category.toUpperCase()
              : 'Product Details',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: const [
          CartBadgeIcon(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Carousel / Header
            Container(
              height: 320,
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              child: Stack(
                children: [
                  if (images.isNotEmpty)
                    PageView.builder(
                      controller: _imagePageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Hero(
                          tag: 'product_image_${product.id}_$index',
                          child: ProductNetworkImage(
                            imageUrl: images[index],
                            placeholderCategory: product.category,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    )
                  else
                    ProductNetworkImage(
                      imageUrl: product.imageUrl,
                      placeholderCategory: product.category,
                      fit: BoxFit.contain,
                    ),

                  // Discount Badge
                  if (hasDiscount)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                  // Page Indicator Dots
                  if (images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          final isSelected = _selectedImageIndex == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: isSelected ? 20 : 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textMuted.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),

            // Product Details Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (product.brand.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.brand.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Price & Stock
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      PriceText.large(price: product.price),
                      if (hasDiscount) ...[
                        const SizedBox(width: 10),
                        Text(
                          '${AppConstants.currencySymbol}${product.originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Stock status
                      _buildStockBadge(product.stock),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),

                  // Description Title
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'No description available for this product.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Specifications Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildSpecRow('Category', product.category),
                        if (product.brand.isNotEmpty) ...[
                          const Divider(height: 20, color: AppColors.border),
                          _buildSpecRow('Brand', product.brand),
                        ],
                        const Divider(height: 20, color: AppColors.border),
                        _buildSpecRow(
                          'Availability',
                          product.stock > 0 ? '${product.stock} in stock' : 'Out of stock',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // spacing for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          final int quantityInCart =
              context.read<CartCubit>().getProductQuantity(product.id);
          final bool isInCart = quantityInCart > 0;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Animated Quantity Selector (Initially hidden, appears when item added to cart)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: isInCart
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _stirController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _wiggleAnimation.value,
                                    child: Transform.scale(
                                      scale: _scaleAnimation.value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        key: const Key('detail_decrease_qty_btn'),
                                        icon: const Icon(Icons.remove, size: 18),
                                        onPressed: _decrementQuantity,
                                        visualDensity: VisualDensity.compact,
                                        tooltip: 'Decrease quantity',
                                      ),
                                      Text(
                                        '$quantityInCart',
                                        key: const Key('detail_qty_text'),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      IconButton(
                                        key: const Key('detail_increase_qty_btn'),
                                        icon: const Icon(Icons.add, size: 18),
                                        onPressed: _incrementQuantity,
                                        visualDensity: VisualDensity.compact,
                                        tooltip: 'Increase quantity',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Main Button: "Add to Cart" or "Checkout"
                  Expanded(
                    child: AppButton(
                      key: Key(isInCart ? 'checkout_button' : 'add_to_cart_button'),
                      text: isInCart
                          ? 'Checkout • ${AppConstants.currencySymbol}${(product.price * quantityInCart).toStringAsFixed(2)}'
                          : 'Add to Cart • ${AppConstants.currencySymbol}${product.price.toStringAsFixed(2)}',
                      icon: isInCart
                          ? Icons.shopping_cart_checkout_rounded
                          : Icons.shopping_bag_outlined,
                      backgroundColor: isInCart ? AppColors.accentDark : AppColors.primary,
                      onPressed: () {
                        if (isInCart) {
                          Navigator.pushNamed(context, AppConstants.routeCart);
                        } else {
                          _addToCart();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

    );
  }

  Widget _buildStockBadge(int stock) {
    Color color = AppColors.success;
    String text = 'In Stock';

    if (stock <= 0) {
      color = AppColors.error;
      text = 'Out of Stock';
    } else if (stock <= 5) {
      color = Colors.orange;
      text = 'Only $stock left!';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
