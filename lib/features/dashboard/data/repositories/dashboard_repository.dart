import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/response/dashboard_stats_response.dart';

class DashboardRepository {
  final ApiService _apiService;

  DashboardRepository(this._apiService);

  Future<ApiResult<DashboardStatsResponse>> getStats() async {
    try {
      final response = await _apiService.getDashboardStats();
      final stats =
          DashboardStatsResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(stats);
    } catch (e) {
      return ApiErrorHandler.handleError<DashboardStatsResponse>(e);
    }
  }

  Future<ApiResult<dynamic>> getSales({
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queries = <String, dynamic>{};
      if (period != null) queries['period'] = period;
      if (startDate != null) queries['startDate'] = startDate;
      if (endDate != null) queries['endDate'] = endDate;

      final response = await _apiService.getDashboardSales(queries);
      return ApiResult.success(response);
    } catch (e) {
      return ApiErrorHandler.handleError<dynamic>(e);
    }
  }

  Future<ApiResult<dynamic>> getTopProducts({
    int limit = 10,
    String? period,
  }) async {
    try {
      final queries = <String, dynamic>{
        'limit': limit,
        if (period != null) 'period': period,
      };

      final response = await _apiService.getTopProducts(queries);
      return ApiResult.success(response);
    } catch (e) {
      return ApiErrorHandler.handleError<dynamic>(e);
    }
  }

  Future<ApiResult<dynamic>> getTrafficSources() async {
    try {
      final response = await _apiService.getTrafficSources();
      return ApiResult.success(response);
    } catch (e) {
      return ApiErrorHandler.handleError<dynamic>(e);
    }
  }

  Future<ApiResult<dynamic>> getRecentActivities({int limit = 10}) async {
    try {
      final queries = <String, dynamic>{'limit': limit};
      final response = await _apiService.getRecentActivities(queries);
      return ApiResult.success(response);
    } catch (e) {
      return ApiErrorHandler.handleError<dynamic>(e);
    }
  }
}
