import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/empty_state_view.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.remove_shopping_cart_outlined,
      title: 'Your cart is empty',
      message:
          'Looks like you haven’t added any fashion pieces yet. Explore our latest arrivals and fill your cart!',
      actionText: 'Continue Shopping',
      actionIcon: Icons.storefront_rounded,
      onAction: () {
        Navigator.popUntil(
          context,
          ModalRoute.withName(AppConstants.routeProducts),
        );
      },
    );
  }
}
