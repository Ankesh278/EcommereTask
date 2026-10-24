import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 50, int skip = 0});
  Future<List<ProductModel>> searchProducts(String query);
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://dummyjson.com';
  static const Duration timeoutDuration = Duration(seconds: 15);

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts({int limit = 50, int skip = 0}) async {
    final uri = Uri.parse('$baseUrl/products?limit=$limit&skip=$skip');
    return _fetchProductsFromUri(uri);
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return getProducts();
    }
    final encoded = Uri.encodeComponent(trimmedQuery);
    final uri = Uri.parse('$baseUrl/products/search?q=$encoded');
    return _fetchProductsFromUri(uri);
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final uri = Uri.parse('$baseUrl/products/$id');
    try {
      final response = await client.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = json.decode(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw const DataParsingException('Product data format is invalid.');
        }
        return ProductModel.fromJson(decoded);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        String message = 'Product not found (Status ${response.statusCode})';
        try {
          final errJson = json.decode(response.body);
          if (errJson is Map && errJson['message'] != null) {
            message = errJson['message'].toString();
          }
        } catch (_) {}
        throw ClientErrorException(message, statusCode: response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ServerException(
          'Server error (${response.statusCode}). Please try again later.',
          statusCode: response.statusCode,
        );
      } else {
        throw ServerException(
          'Unexpected server status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (_) {
      throw const NetworkException(
        'No internet connection. Please check your network settings and try again.',
      );
    } on TimeoutException catch (_) {
      throw const RequestTimeoutException(
        'Connection timed out. The server took too long to respond.',
      );
    } on http.ClientException catch (_) {
      throw const NetworkException(
        'Network error occurred while contacting the server. Please verify your connection.',
      );
    } on FormatException catch (_) {
      throw const DataParsingException(
        'Failed to parse product response from server.',
      );
    }
  }

  Future<List<ProductModel>> _fetchProductsFromUri(Uri uri) async {
    try {
      final response = await client.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = json.decode(response.body);
        if (decoded is! Map<String, dynamic> || decoded['products'] is! List) {
          throw const DataParsingException(
            'Invalid product list format received from server.',
          );
        }
        final list = decoded['products'] as List<dynamic>;
        return list
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        String message = 'Client request failed (Status ${response.statusCode})';
        try {
          final errJson = json.decode(response.body);
          if (errJson is Map && errJson['message'] != null) {
            message = errJson['message'].toString();
          }
        } catch (_) {}
        throw ClientErrorException(message, statusCode: response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ServerException(
          'DummyJSON server error (${response.statusCode}). Please try again later.',
          statusCode: response.statusCode,
        );
      } else {
        throw ServerException(
          'Unexpected response code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (_) {
      throw const NetworkException(
        'No internet connection. Please check your network settings and try again.',
      );
    } on TimeoutException catch (_) {
      throw const RequestTimeoutException(
        'Connection timed out. The server took too long to respond.',
      );
    } on http.ClientException catch (_) {
      throw const NetworkException(
        'Network communication error. Please check your internet connection.',
      );
    } on FormatException catch (_) {
      throw const DataParsingException(
        'Failed to parse products from server JSON.',
      );
    }
  }
}
