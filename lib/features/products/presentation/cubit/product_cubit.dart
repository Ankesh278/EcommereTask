import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase? searchProductsUseCase;

  List<ProductEntity> _allProducts = [];

  ProductCubit({
    required this.getProductsUseCase,
    this.searchProductsUseCase,
  }) : super(const ProductInitial());

  List<ProductEntity> get allProducts => List.unmodifiable(_allProducts);

  Future<void> loadProducts({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(const ProductLoading());
    }

    final result = await getProductsUseCase();

    switch (result) {
      case Success(:final data):
        _allProducts = data;
        emit(ProductLoaded(data));
      case Error(:final failure):
        emit(ProductError(failure.message, failure: failure));
    }
  }

  Future<void> searchProducts(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      if (_allProducts.isNotEmpty) {
        emit(ProductLoaded(_allProducts, searchQuery: ''));
        return;
      }
      return loadProducts();
    }

    emit(const ProductLoading(message: 'Searching products...'));

    if (searchProductsUseCase != null) {
      final result = await searchProductsUseCase!(trimmedQuery);
      switch (result) {
        case Success(:final data):
          emit(ProductLoaded(data, searchQuery: trimmedQuery));
        case Error(:final failure):
          // Client-side fallback if we already have products
          if (_allProducts.isNotEmpty) {
            final filtered = _allProducts.where((p) {
              final q = trimmedQuery.toLowerCase();
              return p.name.toLowerCase().contains(q) ||
                  p.description.toLowerCase().contains(q) ||
                  p.category.toLowerCase().contains(q) ||
                  p.brand.toLowerCase().contains(q);
            }).toList();
            emit(ProductLoaded(filtered, searchQuery: trimmedQuery));
          } else {
            emit(ProductError(failure.message, failure: failure));
          }
      }
    } else {
      // Local filter fallback
      final filtered = _allProducts.where((p) {
        final q = trimmedQuery.toLowerCase();
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q);
      }).toList();
      emit(ProductLoaded(filtered, searchQuery: trimmedQuery));
    }
  }

  void clearSearch() {
    if (_allProducts.isNotEmpty) {
      emit(ProductLoaded(_allProducts, searchQuery: ''));
    } else {
      loadProducts();
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts(isRefresh: true);
  }
}
