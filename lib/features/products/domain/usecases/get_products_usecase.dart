import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  const GetProductsUseCase(this.repository);

  Future<Result<List<ProductEntity>, Failure>> call() {
    return repository.getProducts();
  }
}
