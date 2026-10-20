import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is empty',
              style: AppTextStyles.headingLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Looks like you haven’t added any fashion pieces yet. Explore our latest arrivals and fill your cart!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 220,
              child: AppButton(
                text: 'Continue Shopping',
                icon: Icons.storefront_rounded,
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(AppConstants.routeProducts),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
