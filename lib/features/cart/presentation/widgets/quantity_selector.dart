import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// A reusable quantity increment/decrement selector widget.
/// Encapsulates count presentation and step interactions.
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String? productId;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final isAtMinimum = quantity <= 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement / Delete Button
          _QuantityIconButton(
            key: productId != null ? Key('decrement_$productId') : null,
            icon: isAtMinimum ? Icons.delete_outline : Icons.remove,
            color: isAtMinimum ? AppColors.error : AppColors.textPrimary,
            tooltip: isAtMinimum ? 'Remove item' : 'Decrease quantity',
            onPressed: onDecrement,
          ),

          // Quantity Count Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              key: productId != null ? Key('qty_$productId') : null,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Increment Button
          _QuantityIconButton(
            key: productId != null ? Key('increment_$productId') : null,
            icon: Icons.add,
            color: AppColors.textPrimary,
            tooltip: 'Increase quantity',
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _QuantityIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  const _QuantityIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
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
