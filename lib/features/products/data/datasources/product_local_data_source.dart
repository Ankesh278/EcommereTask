import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const List<Map<String, dynamic>> _staticProductsJson = [
    {
      'id': 'prod_001',
      'name': 'Classic Cotton T-Shirt',
      'description':
          'Breathable 100% combed cotton crewneck t-shirt with durable double-stitched hem and soft everyday feel.',
      'price': 799.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
      'category': 'T-Shirts',
      'rating': 4.7,
    },
    {
      'id': 'prod_002',
      'name': 'Oversized Graphic T-Shirt',
      'description':
          'Trendy dropped-shoulder fit crafted with heavyweight jersey fabric and minimal street-style screen print.',
      'price': 999.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=800&q=80',
      'category': 'T-Shirts',
      'rating': 4.6,
    },
    {
      'id': 'prod_003',
      'name': 'Casual Denim Jacket',
      'description':
          'Timeless vintage blue wash denim jacket featuring brass buttons, dual chest pockets, and adjustable waist tabs.',
      'price': 2499.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=800&q=80',
      'category': 'Outerwear',
      'rating': 4.8,
    },
    {
      'id': 'prod_004',
      'name': 'Slim Fit Jeans',
      'description':
          'Comfortable stretch denim trousers with contemporary tapered legs, 5-pocket styling, and zip fly.',
      'price': 1799.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=800&q=80',
      'category': 'Jeans',
      'rating': 4.5,
    },
    {
      'id': 'prod_005',
      'name': 'Premium Hoodie',
      'description':
          'Cozy fleece-lined pullover hoodie with kangaroo pocket, ribbed cuffs, and drawstring adjustable hood.',
      'price': 1999.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=80',
      'category': 'Hoodies',
      'rating': 4.9,
    },
    {
      'id': 'prod_006',
      'name': 'Casual Linen Shirt',
      'description':
          'Lightweight pure linen button-down shirt designed with breathable weave and relaxed resort collar.',
      'price': 1299.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=800&q=80',
      'category': 'Shirts',
      'rating': 4.6,
    },
    {
      'id': 'prod_007',
      'name': 'Sports Sneakers',
      'description':
          'Versatile lifestyle runners with cushioned EVA midsole, flexible rubber traction outsole, and mesh upper.',
      'price': 2999.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
      'category': 'Footwear',
      'rating': 4.8,
    },
    {
      'id': 'prod_008',
      'name': 'Everyday Backpack',
      'description':
          'Durable water-resistant canvas backpack with padded laptop sleeve, organizer compartments, and ergonomic straps.',
      'price': 1499.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=80',
      'category': 'Accessories',
      'rating': 4.7,
    },
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 350));
      return _staticProductsJson
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ProductException('Failed to load products: ${e.toString()}');
    }
  }
}
