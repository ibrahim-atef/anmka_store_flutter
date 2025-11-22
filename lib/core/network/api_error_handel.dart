import 'package:dio/dio.dart';
import 'api_error_model.dart';
import 'api_result.dart';

class ApiErrorHandler {
  static ApiResult<T> handleError<T>(dynamic error) {
    if (error is DioException) {
      return _handleDioError<T>(error);
    } else if (error is ApiErrorModel) {
      return ApiResult<T>.failure(error);
    } else {
      return ApiResult<T>.failure(
        ApiErrorModel(
          message: error.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  static ApiResult<T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResult<T>.failure(
          const ApiErrorModel(
            message: 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى',
            code: 'TIMEOUT',
            statusCode: 408,
          ),
        );

      case DioExceptionType.badResponse:
        return _handleResponseError<T>(error.response);

      case DioExceptionType.cancel:
        return ApiResult<T>.failure(
          const ApiErrorModel(
            message: 'تم إلغاء الطلب',
            code: 'CANCELLED',
            statusCode: 0,
          ),
        );

      case DioExceptionType.connectionError:
        return ApiResult<T>.failure(
          const ApiErrorModel(
            message: 'خطأ في الاتصال. يرجى التحقق من اتصالك بالإنترنت',
            code: 'CONNECTION_ERROR',
            statusCode: 0,
          ),
        );

      case DioExceptionType.badCertificate:
        return ApiResult<T>.failure(
          const ApiErrorModel(
            message: 'خطأ في شهادة الاتصال',
            code: 'BAD_CERTIFICATE',
            statusCode: 0,
          ),
        );

      case DioExceptionType.unknown:
        return ApiResult<T>.failure(
          ApiErrorModel(
            message: error.message ?? 'حدث خطأ غير متوقع',
            code: 'UNKNOWN',
            statusCode: 500,
          ),
        );
    }
  }

  static ApiResult<T> _handleResponseError<T>(Response? response) {
    if (response == null) {
      return ApiResult<T>.failure(
        const ApiErrorModel(
          message: 'لا توجد استجابة من الخادم',
          code: 'NO_RESPONSE',
          statusCode: 0,
        ),
      );
    }

    final statusCode = response.statusCode ?? 500;
    String message = 'حدث خطأ غير متوقع';

    // Try to parse error from response
    try {
      if (response.data is Map<String, dynamic>) {
        final errorData = response.data as Map<String, dynamic>;
        final errorModel = ApiErrorModel.fromJson({
          ...errorData,
          'statusCode': statusCode,
        });
        message = errorModel.errorMessage;
      } else if (response.data is String) {
        message = response.data as String;
      }
    } catch (e) {
      // If parsing fails, use default message based on status code
      message = _getDefaultErrorMessage(statusCode);
    }

    return ApiResult<T>.failure(
      ApiErrorModel(
        message: message,
        code: statusCode.toString(),
        statusCode: statusCode,
      ),
    );
  }

  static String _getDefaultErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صحيح';
      case 401:
        return 'غير مصرح. يرجى تسجيل الدخول مرة أخرى';
      case 403:
        return 'غير مسموح. ليس لديك الصلاحية للوصول';
      case 404:
        return 'المورد غير موجود';
      case 500:
        return 'خطأ في الخادم. يرجى المحاولة لاحقاً';
      case 502:
        return 'خطأ في البوابة';
      case 503:
        return 'الخدمة غير متاحة حالياً';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
