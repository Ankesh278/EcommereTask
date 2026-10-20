import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/products/presentation/cubit/product_cubit.dart';
import 'features/products/presentation/pages/product_listing_page.dart';
import 'injection_container.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>.value(value: sl<CartCubit>()),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<ProductCubit>(
          create: (_) => sl<ProductCubit>()..loadProducts(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppConstants.routeLogin,
        routes: {
          AppConstants.routeLogin: (context) => const LoginPage(),
          AppConstants.routeProducts: (context) => const ProductListingPage(),
          AppConstants.routeCart: (context) => const CartPage(),
        },
      ),
    );
  }
}
