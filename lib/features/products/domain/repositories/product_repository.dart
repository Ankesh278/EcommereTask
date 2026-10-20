import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Result<List<ProductEntity>, Failure>> getProducts();
}
