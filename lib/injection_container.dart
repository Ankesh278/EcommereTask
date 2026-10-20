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

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ----------------------------------------------------
  // Features - Auth
  // ----------------------------------------------------
  // Cubit (Factory: fresh instance when requested)
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(loginUseCase: sl()),
  );

  // Use Cases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // ----------------------------------------------------
  // Features - Products
  // ----------------------------------------------------
  // Cubit
  sl.registerFactory<ProductCubit>(
    () => ProductCubit(getProductsUseCase: sl()),
  );

  // Use Cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  // ----------------------------------------------------
  // Features - Cart
  // ----------------------------------------------------
  // Use Cases
  sl.registerLazySingleton<CalculateCartTotalUseCase>(
    () => const CalculateCartTotalUseCase(),
  );

  // CartCubit: MUST be a shared Singleton across all screens so that
  // cart contents, quantity modifications, and badge counts are
  // preserved seamlessly when navigating between screens.
  sl.registerLazySingleton<CartCubit>(
    () => CartCubit(),
  );
}
