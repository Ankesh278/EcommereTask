import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.rating,
    super.brand = '',
    super.stock = 0,
    super.discountPercentage = 0.0,
    super.images = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle images array
    final rawImages = json['images'];
    List<String> imageList = [];
    if (rawImages is List) {
      imageList = rawImages.map((e) => e.toString()).toList();
    }

    // Handle thumbnail or imageUrl
    String imgUrl = '';
    if (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty) {
      imgUrl = json['thumbnail'].toString();
    } else if (json['imageUrl'] != null &&
        json['imageUrl'].toString().isNotEmpty) {
      imgUrl = json['imageUrl'].toString();
    } else if (imageList.isNotEmpty) {
      imgUrl = imageList.first;
    }

    // Name or title
    final title = (json['title'] ?? json['name'] ?? '').toString();

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: title,
      description: (json['description'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: imgUrl,
      category: (json['category'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      brand: (json['brand'] ?? '').toString(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      images: imageList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'thumbnail': imageUrl,
      'category': category,
      'rating': rating,
      'brand': brand,
      'stock': stock,
      'discountPercentage': discountPercentage,
      'images': images,
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      category: entity.category,
      rating: entity.rating,
      brand: entity.brand,
      stock: entity.stock,
      discountPercentage: entity.discountPercentage,
      images: entity.images,
    );
  }
}

