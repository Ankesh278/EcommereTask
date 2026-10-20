import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  const ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<ProductEntity>, Failure>> getProducts() async {
    try {
      final products = await localDataSource.getProducts();
      return Success(products);
    } on ProductException catch (e) {
      return Error(ProductFailure(e.message));
    } catch (e) {
      return Error(ProductFailure('Unexpected error loading products: $e'));
    }
  }
}
