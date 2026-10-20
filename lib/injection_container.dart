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

final serviceLocator = GetIt.instance;
final sl = serviceLocator;

Future<void> initDependencies() async {
  serviceLocator.registerFactory<AuthCubit>(
    () => AuthCubit(loginUseCase: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  serviceLocator.registerFactory<ProductCubit>(
    () => ProductCubit(getProductsUseCase: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(localDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  serviceLocator.registerLazySingleton<CalculateCartTotalUseCase>(
    () => const CalculateCartTotalUseCase(),
  );

  serviceLocator.registerLazySingleton<CartCubit>(() => CartCubit());
}
