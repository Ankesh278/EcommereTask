import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository repository;

  const SearchProductsUseCase(this.repository);

  Future<Result<List<ProductEntity>, Failure>> call(String query) {
    return repository.searchProducts(query);
  }
}
