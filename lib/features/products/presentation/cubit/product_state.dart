import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  final String? message;
  const ProductLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final String searchQuery;

  const ProductLoaded(this.products, {this.searchQuery = ''});

  @override
  List<Object?> get props => [products, searchQuery];
}

class ProductError extends ProductState {
  final String message;
  final Failure? failure;

  const ProductError(this.message, {this.failure});

  @override
  List<Object?> get props => [message, failure];
}
