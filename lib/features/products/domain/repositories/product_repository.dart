import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Result<List<ProductEntity>, Failure>> getProducts();
  Future<Result<List<ProductEntity>, Failure>> searchProducts(String query);
  Future<Result<ProductEntity, Failure>> getProductById(String id);
}

