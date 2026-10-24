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
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException ($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([
    this.message = 'No internet connection. Please check your network settings and try again.',
  ]);

  @override
  String toString() => 'NetworkException: $message';
}

class RequestTimeoutException implements Exception {
  final String message;
  const RequestTimeoutException([
    this.message = 'Connection timed out. The server took too long to respond.',
  ]);

  @override
  String toString() => 'RequestTimeoutException: $message';
}

class ClientErrorException implements Exception {
  final String message;
  final int statusCode;
  const ClientErrorException(this.message, {required this.statusCode});

  @override
  String toString() => 'ClientErrorException ($statusCode): $message';
}

class DataParsingException implements Exception {
  final String message;
  const DataParsingException([
    this.message = 'Invalid data received from server. Please try again later.',
  ]);

  @override
  String toString() => 'DataParsingException: $message';
}

