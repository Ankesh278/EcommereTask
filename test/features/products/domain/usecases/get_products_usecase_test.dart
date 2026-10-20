import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercetask/core/errors/failures.dart';
import 'package:ecommercetask/core/utils/result.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';
import 'package:ecommercetask/features/products/domain/repositories/product_repository.dart';
import 'package:ecommercetask/features/products/domain/usecases/get_products_usecase.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  const tProduct = ProductEntity(
    id: 'prod_001',
    name: 'Denim Jacket',
    description: 'Classic denim jacket',
    price: 89.99,
    imageUrl: 'https://example.com/denim.jpg',
    category: 'Outerwear',
    rating: 4.8,
  );

  final tProductList = [tProduct];

  test('should return list of products from the repository', () async {
    // Arrange
    when(
      () => mockRepository.getProducts(),
    ).thenAnswer((_) async => Success(tProductList));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Success<List<ProductEntity>, Failure>(tProductList));
    verify(() => mockRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ProductFailure when repository call fails', () async {
    // Arrange
    const tFailure = ProductFailure('Failed to fetch products');
    when(
      () => mockRepository.getProducts(),
    ).thenAnswer((_) async => const Error(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Error<List<ProductEntity>, Failure>(tFailure));
    verify(() => mockRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
