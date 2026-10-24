import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'app_shimmer.dart';

class ProductNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final String? placeholderCategory;
  final IconData placeholderIcon;
  final bool showShimmer;

  const ProductNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderCategory,
    this.placeholderIcon = Icons.checkroom_rounded,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        if (!showShimmer) {
          return _buildPlaceholder();
        }
        return AppShimmer(
          width: width,
          height: height,
          child: _buildPlaceholder(isShimmering: true),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );

    if (aspectRatio != null) {
      imageWidget = AspectRatio(aspectRatio: aspectRatio!, child: imageWidget);
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder({bool isShimmering = false}) {
    return Container(
      width: width,
      height: height,
      color: isShimmering ? Colors.transparent : AppColors.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            placeholderIcon,
            size: (height != null && height! < 80) ? 32 : 44,
            color: isShimmering
                ? AppColors.textMuted.withValues(alpha: 0.3)
                : AppColors.textMuted.withValues(alpha: 0.7),
          ),
          if (placeholderCategory != null &&
              (height == null || height! >= 80)) ...[
            const SizedBox(height: AppDimensions.spacingExtraSmall),
            Text(
              placeholderCategory!,
              style: TextStyle(
                fontSize: 11,
                color: isShimmering
                    ? AppColors.textSecondary.withValues(alpha: 0.4)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
