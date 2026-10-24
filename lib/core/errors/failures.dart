import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ProductFailure extends Failure {
  const ProductFailure(super.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network settings and try again.',
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Connection timed out. The server took too long to respond.',
  ]);
}

class ClientErrorFailure extends Failure {
  final int statusCode;
  const ClientErrorFailure(super.message, {required this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class DataParsingFailure extends Failure {
  const DataParsingFailure([
    super.message = 'Failed to process server response. Please try again later.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

