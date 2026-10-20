import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercetask/core/errors/failures.dart';
import 'package:ecommercetask/core/utils/result.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';
import 'package:ecommercetask/features/products/domain/repositories/product_repository.dart';
import 'package:ecommercetask/features/products/domain/usecases/get_products_usecase.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase getProductsUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getProductsUseCase = GetProductsUseCase(mockProductRepository);
  });

  const sampleProduct = ProductEntity(
    id: 'prod_001',
    name: 'Denim Jacket',
    description: 'Classic denim jacket',
    price: 89.99,
    imageUrl: 'https://example.com/denim.jpg',
    category: 'Outerwear',
    rating: 4.8,
  );

  final sampleProductList = [sampleProduct];

  test('should return list of products from the repository', () async {
    // Arrange
    when(
      () => mockProductRepository.getProducts(),
    ).thenAnswer((_) async => Success(sampleProductList));

    // Act
    final loadResult = await getProductsUseCase();

    // Assert
    expect(
      loadResult,
      Success<List<ProductEntity>, Failure>(sampleProductList),
    );
    verify(() => mockProductRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('should return ProductFailure when repository call fails', () async {
    // Arrange
    const sampleFailure = ProductFailure('Failed to fetch products');
    when(
      () => mockProductRepository.getProducts(),
    ).thenAnswer((_) async => const Error(sampleFailure));

    // Act
    final loadResult = await getProductsUseCase();

    // Assert
    expect(
      loadResult,
      const Error<List<ProductEntity>, Failure>(sampleFailure),
    );
    verify(() => mockProductRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });
}
