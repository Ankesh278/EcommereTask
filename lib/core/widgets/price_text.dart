import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../theme/app_text_styles.dart';

enum PriceTextSize { small, medium, large, total }

/// A reusable price display widget adhering to Clean Architecture & DRY.
/// Formats any numeric price with the app currency symbol and typography styles.
class PriceText extends StatelessWidget {
  final num price;
  final PriceTextSize size;
  final Color? color;
  final String? suffix;
  final FontWeight? fontWeight;

  const PriceText({
    super.key,
    required this.price,
    this.size = PriceTextSize.medium,
    this.color,
    this.suffix,
    this.fontWeight,
  });

  /// Factory constructor for small price label (e.g. cart items / unit price)
  factory PriceText.small({
    Key? key,
    required num price,
    Color? color,
    String? suffix,
  }) {
    return PriceText(
      key: key,
      price: price,
      size: PriceTextSize.small,
      color: color,
      suffix: suffix,
    );
  }

  /// Factory constructor for large hero price (e.g. product details sheet)
  factory PriceText.large({
    Key? key,
    required num price,
    Color? color,
    String? suffix,
  }) {
    return PriceText(
      key: key,
      price: price,
      size: PriceTextSize.large,
      color: color,
      suffix: suffix,
    );
  }

  /// Factory constructor for cart total summary price
  factory PriceText.total({Key? key, required num price, Color? color}) {
    return PriceText(
      key: key,
      price: price,
      size: PriceTextSize.total,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = '${AppConstants.currencySymbol}${price.toInt()}';
    final displayText = suffix != null
        ? '$formattedPrice $suffix'
        : formattedPrice;
    final textStyle = _resolveStyle();

    return Text(displayText, style: textStyle);
  }

  TextStyle _resolveStyle() {
    switch (size) {
      case PriceTextSize.small:
        return TextStyle(
          fontSize: 12,
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color ?? AppColors.textSecondary,
        );
      case PriceTextSize.medium:
        return TextStyle(
          fontSize: 15,
          fontWeight: fontWeight ?? FontWeight.w800,
          color: color ?? AppColors.textPrimary,
        );
      case PriceTextSize.large:
        return AppTextStyles.price.copyWith(
          fontSize: 24,
          fontWeight: fontWeight ?? FontWeight.w800,
          color: color ?? AppColors.primary,
        );
      case PriceTextSize.total:
        return AppTextStyles.priceTotal.copyWith(
          color: color ?? AppColors.primary,
          fontWeight: fontWeight ?? FontWeight.w900,
        );
    }
  }
}
