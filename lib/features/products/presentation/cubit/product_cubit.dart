import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductCubit({required this.getProductsUseCase})
      : super(const ProductInitial());

  Future<void> loadProducts() async {
    emit(const ProductLoading());

    final result = await getProductsUseCase();

    switch (result) {
      case Success(:final data):
        emit(ProductLoaded(data));
      case Error(:final failure):
        emit(ProductError(failure.message));
    }
  }
}
