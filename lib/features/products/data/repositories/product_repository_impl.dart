import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource? localDataSource;

  const ProductRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<Result<List<ProductEntity>, Failure>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Success(products);
    } on NetworkException catch (e) {
      return Error(NetworkFailure(e.message));
    } on RequestTimeoutException catch (e) {
      return Error(TimeoutFailure(e.message));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message, statusCode: e.statusCode));
    } on ClientErrorException catch (e) {
      return Error(ClientErrorFailure(e.message, statusCode: e.statusCode));
    } on DataParsingException catch (e) {
      return Error(DataParsingFailure(e.message));
    } on ProductException catch (e) {
      return Error(ProductFailure(e.message));
    } catch (e) {
      return Error(ProductFailure('Unexpected error loading products: $e'));
    }
  }

  @override
  Future<Result<List<ProductEntity>, Failure>> searchProducts(
    String query,
  ) async {
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Success(products);
    } on NetworkException catch (e) {
      return Error(NetworkFailure(e.message));
    } on RequestTimeoutException catch (e) {
      return Error(TimeoutFailure(e.message));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message, statusCode: e.statusCode));
    } on ClientErrorException catch (e) {
      return Error(ClientErrorFailure(e.message, statusCode: e.statusCode));
    } on DataParsingException catch (e) {
      return Error(DataParsingFailure(e.message));
    } on ProductException catch (e) {
      return Error(ProductFailure(e.message));
    } catch (e) {
      return Error(ProductFailure('Unexpected error searching products: $e'));
    }
  }

  @override
  Future<Result<ProductEntity, Failure>> getProductById(String id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Success(product);
    } on NetworkException catch (e) {
      return Error(NetworkFailure(e.message));
    } on RequestTimeoutException catch (e) {
      return Error(TimeoutFailure(e.message));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message, statusCode: e.statusCode));
    } on ClientErrorException catch (e) {
      return Error(ClientErrorFailure(e.message, statusCode: e.statusCode));
    } on DataParsingException catch (e) {
      return Error(DataParsingFailure(e.message));
    } on ProductException catch (e) {
      return Error(ProductFailure(e.message));
    } catch (e) {
      return Error(ProductFailure('Unexpected error loading product: $e'));
    }
  }
}
