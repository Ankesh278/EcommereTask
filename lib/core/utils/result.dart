import 'package:equatable/equatable.dart';

sealed class Result<S, F> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isError => this is Error<S, F>;

  S? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Error() => null,
      };

  F? get errorOrNull => switch (this) {
        Success() => null,
        Error(:final failure) => failure,
      };

  R fold<R>(R Function(F failure) onError, R Function(S data) onSuccess) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Error(:final failure) => onError(failure),
    };
  }
}

class Success<S, F> extends Result<S, F> {
  final S data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Error<S, F> extends Result<S, F> {
  final F failure;

  const Error(this.failure);

  @override
  List<Object?> get props => [failure];
}
