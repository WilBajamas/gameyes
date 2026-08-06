import 'package:dio/dio.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin BaseRepositoryMixin {
  Future<Result<T>> fetchData<T>({required Future<T> apiCall}) async {
    try {
      final response = await apiCall;

      return Success(response);
    } on DioException catch (dioException) {
      return Failure(ErrorType.dioError(exception: dioException));
    } on FunctionException catch (functionException) {
      return Failure(ErrorType.functionError(exception: functionException));
    } catch (_) {
      return Failure(ErrorType.unknown());
    }
  }
}
