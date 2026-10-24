import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final String brand;
  final int stock;
  final double discountPercentage;
  final List<String> images;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    this.brand = '',
    this.stock = 0,
    this.discountPercentage = 0.0,
    this.images = const [],
  });

  /// Alias for name to match title in DummyJSON API
  String get title => name;

  /// Calculate original price before discount
  double get originalPrice =>
      discountPercentage > 0 ? price / (1 - (discountPercentage / 100)) : price;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    category,
    rating,
    brand,
    stock,
    discountPercentage,
    images,
  ];
}

