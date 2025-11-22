import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/request/forgot_password_request.dart';
import '../models/request/login_request.dart';
import '../models/response/login_response.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiService.login(request.toJson());
      final loginResponse =
          LoginResponse.fromJson(response as Map<String, dynamic>);

      // Set token in DioFactory
      DioFactory.setToken(loginResponse.token);

      return ApiResult.success(loginResponse);
    } catch (e) {
      return ApiErrorHandler.handleError<LoginResponse>(e);
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      await _apiService.logout();
      DioFactory.clearToken();
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }

  Future<ApiResult<void>> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await _apiService.forgotPassword(request.toJson());
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }
}
