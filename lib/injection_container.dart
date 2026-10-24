import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/domain/usecases/search_products_usecase.dart';
import 'features/products/presentation/cubit/product_cubit.dart';

import 'features/cart/domain/usecases/calculate_cart_total_usecase.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';

final serviceLocator = GetIt.instance;
final sl = serviceLocator;

Future<void> initDependencies() async {
  // External
  if (!serviceLocator.isRegistered<http.Client>()) {
    serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  }

  // Auth Feature
  if (!serviceLocator.isRegistered<AuthLocalDataSource>()) {
    serviceLocator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );
  }

  if (!serviceLocator.isRegistered<AuthRepository>()) {
    serviceLocator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(localDataSource: serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<LoginUseCase>()) {
    serviceLocator.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<AuthCubit>()) {
    serviceLocator.registerFactory<AuthCubit>(
      () => AuthCubit(loginUseCase: serviceLocator()),
    );
  }

  // Product Feature - DataSources
  if (!serviceLocator.isRegistered<ProductRemoteDataSource>()) {
    serviceLocator.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<ProductLocalDataSource>()) {
    serviceLocator.registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(),
    );
  }

  // Product Feature - Repositories
  if (!serviceLocator.isRegistered<ProductRepository>()) {
    serviceLocator.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
      ),
    );
  }

  // Product Feature - UseCases
  if (!serviceLocator.isRegistered<GetProductsUseCase>()) {
    serviceLocator.registerLazySingleton<GetProductsUseCase>(
      () => GetProductsUseCase(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<SearchProductsUseCase>()) {
    serviceLocator.registerLazySingleton<SearchProductsUseCase>(
      () => SearchProductsUseCase(serviceLocator()),
    );
  }

  if (!serviceLocator.isRegistered<GetProductByIdUseCase>()) {
    serviceLocator.registerLazySingleton<GetProductByIdUseCase>(
      () => GetProductByIdUseCase(serviceLocator()),
    );
  }

  // Product Feature - Cubit
  if (!serviceLocator.isRegistered<ProductCubit>()) {
    serviceLocator.registerFactory<ProductCubit>(
      () => ProductCubit(
        getProductsUseCase: serviceLocator(),
        searchProductsUseCase: serviceLocator(),
      ),
    );
  }

  // Cart Feature
  if (!serviceLocator.isRegistered<CalculateCartTotalUseCase>()) {
    serviceLocator.registerLazySingleton<CalculateCartTotalUseCase>(
      () => const CalculateCartTotalUseCase(),
    );
  }

  if (!serviceLocator.isRegistered<CartCubit>()) {
    serviceLocator.registerLazySingleton<CartCubit>(() => CartCubit());
  }
}
