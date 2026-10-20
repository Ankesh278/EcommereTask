import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/products/presentation/pages/product_listing_page.dart';
import 'app_route_names.dart';

class AppRouter {
  const AppRouter._();
  static String get initialRoute => AppRouteNames.login;

  static Map<String, WidgetBuilder> get routes => {
    AppRouteNames.login: (context) => const LoginPage(),
    AppRouteNames.products: (context) => const ProductListingPage(),
    AppRouteNames.cart: (context) => const CartPage(),
  };
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
