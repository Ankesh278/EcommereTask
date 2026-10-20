import '../routes/app_route_names.dart';

class AppConstants {
  static const String appTitle = 'AuraWear Fashion';
  static const String currencySymbol = '₹';

  // Primary demo authentication credentials
  static const String demoEmail = 'demo@example.com';
  static const String demoPassword = 'Demo@123';
  static const String demoUserName = 'Demo Shopper';

  // Alternative dummy credentials for testing compatibility
  static const String dummyEmail = 'user@example.com';
  static const String dummyPassword = 'password123';
  static const String dummyUserName = 'Alex Morgan';

  // Named routes linked to separated AppRouteNames
  static const String routeLogin = AppRouteNames.login;
  static const String routeProducts = AppRouteNames.products;
  static const String routeCart = AppRouteNames.cart;
}
