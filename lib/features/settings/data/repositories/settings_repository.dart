import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/request/invite_team_member_request.dart';
import '../models/request/update_notification_settings_request.dart';
import '../models/request/update_store_settings_request.dart';
import '../models/response/notification_settings_response.dart';
import '../models/response/store_settings_response.dart';
import '../models/response/team_list_response.dart';

class SettingsRepository {
  final ApiService _apiService;

  SettingsRepository(this._apiService);

  Future<ApiResult<StoreSettingsResponse>> getStoreSettings() async {
    try {
      final response = await _apiService.getStoreSettings();
      final settings =
          StoreSettingsResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(settings);
    } catch (e) {
      return ApiErrorHandler.handleError<StoreSettingsResponse>(e);
    }
  }

  Future<ApiResult<StoreSettingsResponse>> updateStoreSettings(
      UpdateStoreSettingsRequest request) async {
    try {
      final response = await _apiService.updateStoreSettings(request.toJson());
      final settings =
          StoreSettingsResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(settings);
    } catch (e) {
      return ApiErrorHandler.handleError<StoreSettingsResponse>(e);
    }
  }

  Future<ApiResult<NotificationSettingsResponse>> getNotificationSettings() async {
    try {
      final response = await _apiService.getNotificationSettings();
      final settings = NotificationSettingsResponse.fromJson(
          response as Map<String, dynamic>);
      return ApiResult.success(settings);
    } catch (e) {
      return ApiErrorHandler.handleError<NotificationSettingsResponse>(e);
    }
  }

  Future<ApiResult<NotificationSettingsResponse>> updateNotificationSettings(
      UpdateNotificationSettingsRequest request) async {
    try {
      final response =
          await _apiService.updateNotificationSettings(request.toJson());
      final settings = NotificationSettingsResponse.fromJson(
          response as Map<String, dynamic>);
      return ApiResult.success(settings);
    } catch (e) {
      return ApiErrorHandler.handleError<NotificationSettingsResponse>(e);
    }
  }

  Future<ApiResult<TeamListResponse>> getTeam() async {
    try {
      final response = await _apiService.getTeam();
      final team =
          TeamListResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(team);
    } catch (e) {
      return ApiErrorHandler.handleError<TeamListResponse>(e);
    }
  }

  Future<ApiResult<void>> inviteTeamMember(
      InviteTeamMemberRequest request) async {
    try {
      await _apiService.inviteTeamMember(request.toJson());
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }

  Future<ApiResult<void>> resetTeamPassword(int id) async {
    try {
      await _apiService.resetTeamPassword(id);
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }
}

