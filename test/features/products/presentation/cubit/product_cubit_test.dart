import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommercetask/core/errors/failures.dart';
import 'package:ecommercetask/core/utils/result.dart';
import 'package:ecommercetask/features/products/domain/entities/product_entity.dart';
import 'package:ecommercetask/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ecommercetask/features/products/presentation/cubit/product_cubit.dart';
import 'package:ecommercetask/features/products/presentation/cubit/product_state.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

void main() {
  late ProductCubit productCubit;
  late MockGetProductsUseCase mockGetProductsUseCase;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    productCubit = ProductCubit(getProductsUseCase: mockGetProductsUseCase);
  });

  tearDown(() {
    productCubit.close();
  });

  final sampleProductList = List.generate(
    6,
    (index) => ProductEntity(
      id: 'prod_$index',
      name: 'Item $index',
      description: 'Description $index',
      price: 20.0 + (index * 10),
      imageUrl: 'https://example.com/img_$index.jpg',
      category: 'Clothing',
      rating: 4.5,
    ),
  );

  test('initial state should be ProductInitial', () {
    expect(productCubit.state, const ProductInitial());
  });

  blocTest<ProductCubit, ProductState>(
    'emits [ProductLoading, ProductLoaded] when loadProducts succeeds with >= 5 products',
    build: () {
      when(
        () => mockGetProductsUseCase(),
      ).thenAnswer((_) async => Success(sampleProductList));
      return productCubit;
    },
    act: (cubit) => cubit.loadProducts(),
    expect: () => [const ProductLoading(), ProductLoaded(sampleProductList)],
    verify: (_) {
      verify(() => mockGetProductsUseCase()).called(1);
      expect(sampleProductList.length, greaterThanOrEqualTo(5));
    },
  );

  blocTest<ProductCubit, ProductState>(
    'emits [ProductLoading, ProductError] when loadProducts fails',
    build: () {
      when(() => mockGetProductsUseCase()).thenAnswer(
        (_) async => const Error(ProductFailure('Server connection failed')),
      );
      return productCubit;
    },
    act: (cubit) => cubit.loadProducts(),
    expect: () => [
      const ProductLoading(),
      const ProductError('Server connection failed'),
    ],
    verify: (_) {
      verify(() => mockGetProductsUseCase()).called(1);
    },
  );
}
