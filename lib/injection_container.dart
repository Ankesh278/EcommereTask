import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/presentation/cubit/product_cubit.dart';

import 'features/cart/domain/usecases/calculate_cart_total_usecase.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';

/// Central Dependency Injection Service Locator.
/// Named plainly and directly according to its architectural role.
final serviceLocator = GetIt.instance;

/// Short alias for backwards compatibility with tests and callers.
final sl = serviceLocator;

Future<void> initDependencies() async {
  // ----------------------------------------------------
  // Features - Authentication
  // ----------------------------------------------------
  // Cubit (Factory: fresh instance whenever requested by a route)
  serviceLocator.registerFactory<AuthCubit>(
    () => AuthCubit(loginUseCase: serviceLocator()),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: serviceLocator()),
  );

  // Data Source
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // ----------------------------------------------------
  // Features - Products
  // ----------------------------------------------------
  // Cubit
  serviceLocator.registerFactory<ProductCubit>(
    () => ProductCubit(getProductsUseCase: serviceLocator()),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(localDataSource: serviceLocator()),
  );

  // Data Source
  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  // ----------------------------------------------------
  // Features - Cart
  // ----------------------------------------------------
  // Use Cases
  serviceLocator.registerLazySingleton<CalculateCartTotalUseCase>(
    () => const CalculateCartTotalUseCase(),
  );

  // CartCubit: Registered as a LazySingleton so cart state is shared
  // across all screens (Product Listing, Cart Screen, Details Modal).
  serviceLocator.registerLazySingleton<CartCubit>(() => CartCubit());
}
