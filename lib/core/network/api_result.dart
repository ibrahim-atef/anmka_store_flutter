import 'package:json_annotation/json_annotation.dart';
import 'api_error_model.dart';

part 'api_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResult<T> {
  final bool success;
  final T? data;
  final ApiErrorModel? error;

  const ApiResult({
    required this.success,
    this.data,
    this.error,
  });

  factory ApiResult.success(T data) {
    return ApiResult<T>(
      success: true,
      data: data,
    );
  }

  factory ApiResult.failure(ApiErrorModel error) {
    return ApiResult<T>(
      success: false,
      error: error,
    );
  }

  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResultToJson(this, toJsonT);

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiErrorModel error) failure,
  }) {
    if (this.success) {
      // If we have data, use it
      if (data != null) {
        return success(data as T);
      }
      // For void type (used in delete operations), null data is valid
      // For other types, null data on success indicates a problem
      // We'll try to call success with null and let the type system handle it
      // If T doesn't accept null, the caller should handle it appropriately
      return success(null as T);
    } else if (error != null) {
      return failure(error!);
    } else {
      // This shouldn't happen in normal flow, but handle it gracefully
      return failure(
        const ApiErrorModel(
          message: 'حدث خطأ غير متوقع',
          code: 'UNKNOWN_ERROR',
          statusCode: 500,
        ),
      );
    }
  }
}

