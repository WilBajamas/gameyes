import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';

sealed class Result<T> {
  const Result();

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(value: final value) => Success(transform(value)),
      Failure(error: final error) => Failure(error),
    };
  }
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final ErrorType error;
  const Failure(this.error);
}
