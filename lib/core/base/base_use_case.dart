import 'package:dartz/dartz.dart';

class BaseUseCase<E, R> {
  void run<F>(
    Future<Either> function,
    Function(E failure) onFailure,
    Function(R result) onSuccess,
  ) async {
    final result = await function;
    result.fold((l) => onFailure, (r) => onSuccess);
  }
}
