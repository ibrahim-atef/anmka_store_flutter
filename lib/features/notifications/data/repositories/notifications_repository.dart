import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/response/notifications_list_response.dart';

class NotificationsRepository {
  final ApiService _apiService;

  NotificationsRepository(this._apiService);

  Future<ApiResult<NotificationsListResponse>> getNotifications({
    String? category,
    bool? read,
    int? limit,
  }) async {
    try {
      final queries = <String, dynamic>{};
      if (category != null && category.isNotEmpty) {
        queries['category'] = category;
      }
      if (read != null) {
        queries['read'] = read.toString();
      }
      if (limit != null) {
        queries['limit'] = limit;
      }

      final response = await _apiService.getNotifications(queries.isEmpty ? null : queries);
      final notificationsList =
          NotificationsListResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(notificationsList);
    } catch (e) {
      return ApiErrorHandler.handleError<NotificationsListResponse>(e);
    }
  }

  Future<ApiResult<void>> markNotificationAsRead(int id) async {
    try {
      await _apiService.markNotificationAsRead(id);
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }

  Future<ApiResult<void>> markAllNotificationsAsRead() async {
    try {
      await _apiService.markAllNotificationsAsRead();
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }
}

