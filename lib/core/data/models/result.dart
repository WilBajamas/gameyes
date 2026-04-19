import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final ErrorType error;
  const Failure(this.error);
}
