class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class ProductException implements Exception {
  final String message;
  const ProductException(this.message);

  @override
  String toString() => 'ProductException: $message';
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}
