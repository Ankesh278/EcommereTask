import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/products/presentation/pages/product_listing_page.dart';
import 'app_route_names.dart';

/// Centralized application route definitions and route generation.
/// Completely separates screen navigation and page wiring from the main app entrypoint.
class AppRouter {
  const AppRouter._();

  /// Initial route for the application
  static String get initialRoute => AppRouteNames.login;

  /// Map of static routes
  static Map<String, WidgetBuilder> get routes => {
    AppRouteNames.login: (context) => const LoginPage(),
    AppRouteNames.products: (context) => const ProductListingPage(),
    AppRouteNames.cart: (context) => const CartPage(),
  };

  /// Dynamic route generator for handling transitions and unknown route fallbacks
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case AppRouteNames.products:
        return MaterialPageRoute<void>(
          builder: (_) => const ProductListingPage(),
          settings: settings,
        );

      case AppRouteNames.cart:
        return MaterialPageRoute<void>(
          builder: (_) => const CartPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
