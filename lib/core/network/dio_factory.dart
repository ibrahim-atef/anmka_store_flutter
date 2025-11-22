import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helper/shared_pref_helper.dart';
import 'api_constants.dart';

class DioFactory {
  static Dio? _dio;
  static String? _token;

  static Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  /// Initialize and load token from secure storage
  static Future<void> initialize() async {
    final token = await SharedPrefHelper.getSecuredString(SharedPrefHelper.tokenKey);
    if (token.isNotEmpty) {
      await setToken(token);
    }
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add token to headers if available
          if (_token != null && _token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    // Add logger in debug mode
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    return dio;
  }

  static Future<void> setToken(String? token) async {
    _token = token;
    // Save token to secure storage
    if (token != null && token.isNotEmpty) {
      await SharedPrefHelper.setSecuredString(SharedPrefHelper.tokenKey, token);
    } else {
      await SharedPrefHelper.clearAllSecuredData();
    }
    // Update existing dio instance headers
    if (_dio != null) {
      if (token != null && token.isNotEmpty) {
        _dio!.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio!.options.headers.remove('Authorization');
      }
    }
  }

  static String? get token => _token;

  static Future<void> clearToken() async {
    _token = null;
    await SharedPrefHelper.clearAllSecuredData();
    if (_dio != null) {
      _dio!.options.headers.remove('Authorization');
    }
  }

  static void reset() {
    _dio = null;
    _token = null;
  }
}

