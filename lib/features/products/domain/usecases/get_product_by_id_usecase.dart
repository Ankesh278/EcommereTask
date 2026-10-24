import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  const GetProductByIdUseCase(this.repository);

  Future<Result<ProductEntity, Failure>> call(String id) {
    return repository.getProductById(id);
  }
}
