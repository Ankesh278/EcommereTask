import 'package:equatable/equatable.dart';

sealed class Result<SuccessData, FailureData> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<SuccessData, FailureData>;
  bool get isError => this is Error<SuccessData, FailureData>;

  SuccessData? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Error() => null,
  };

  FailureData? get errorOrNull => switch (this) {
    Success() => null,
    Error(:final failure) => failure,
  };

  ReturnType fold<ReturnType>(
    ReturnType Function(FailureData failure) onFailure,
    ReturnType Function(SuccessData data) onSuccess,
  ) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Error(:final failure) => onFailure(failure),
    };
  }
}

class Success<SuccessData, FailureData>
    extends Result<SuccessData, FailureData> {
  final SuccessData data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Error<SuccessData, FailureData> extends Result<SuccessData, FailureData> {
  final FailureData failure;

  const Error(this.failure);

  @override
  List<Object?> get props => [failure];
}
