import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';
import '../../injection_container.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>.value(value: serviceLocator<CartCubit>()),
        BlocProvider<AuthCubit>(
          create: (context) => serviceLocator<AuthCubit>(),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => serviceLocator<ProductCubit>()..loadProducts(),
        ),
      ],
      child: child,
    );
  }
}
