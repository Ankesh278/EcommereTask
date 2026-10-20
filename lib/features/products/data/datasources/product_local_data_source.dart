import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  // Static clothing catalog with realistic mock items
  static const List<Map<String, dynamic>> _staticProductsJson = [
    {
      'id': 'prod_001',
      'name': 'Heritage Denim Jacket',
      'description':
          'Crafted from 100% durable organic cotton denim with brass hardware, vintage wash, and classic chest flap pockets.',
      'price': 89.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=800&q=80',
      'category': 'Outerwear',
      'rating': 4.8,
    },
    {
      'id': 'prod_002',
      'name': 'Premium Pima Crewneck T-Shirt',
      'description':
          'Ultra-soft Peruvian Pima cotton with tailored fit, breathable jersey weave, and reinforced collar stitching.',
      'price': 34.50,
      'imageUrl':
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
      'category': 'Tops',
      'rating': 4.6,
    },
    {
      'id': 'prod_003',
      'name': 'Slim Stretch Chino Pants',
      'description':
          'Modern slim-tapered chinos made with cotton-twill stretch blend, perfect for both smart-casual and weekend styling.',
      'price': 59.00,
      'imageUrl':
          'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80',
      'category': 'Bottoms',
      'rating': 4.7,
    },
    {
      'id': 'prod_004',
      'name': 'Merino Wool Ribbed Sweater',
      'description':
          '100% extrafine merino wool offering natural thermal regulation, lightweight warmth, and a sophisticated ribbed knit texture.',
      'price': 98.00,
      'imageUrl':
          'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&w=800&q=80',
      'category': 'Knitwear',
      'rating': 4.9,
    },
    {
      'id': 'prod_005',
      'name': 'Urban Technical Hooded Parka',
      'description':
          'Waterproof and windproof shell with recycled insulation, storm cuffs, and deep utility fleece-lined pockets.',
      'price': 149.95,
      'imageUrl':
          'https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=800&q=80',
      'category': 'Outerwear',
      'rating': 4.9,
    },
    {
      'id': 'prod_006',
      'name': 'Classic Oxford Cotton Shirt',
      'description':
          'Crisp yarn-dyed oxford weave button-down shirt designed with buttoned collar, box pleat, and curved hem.',
      'price': 48.00,
      'imageUrl':
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=800&q=80',
      'category': 'Shirts',
      'rating': 4.5,
    },
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Simulate brief loading delay
      await Future.delayed(const Duration(milliseconds: 400));
      return _staticProductsJson
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ProductException('Failed to load products: ${e.toString()}');
    }
  }
}
