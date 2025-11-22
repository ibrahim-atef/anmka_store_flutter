import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/request/create_shipping_zone_request.dart';
import '../models/request/update_shipping_zone_request.dart';
import '../models/response/shipping_zone_response.dart';
import '../models/response/shipping_zones_list_response.dart';
import '../models/response/tracking_updates_list_response.dart';

class ShippingRepository {
  final ApiService _apiService;

  ShippingRepository(this._apiService);

  Future<ApiResult<ShippingZonesListResponse>> getShippingZones() async {
    try {
      final response = await _apiService.getShippingZones();
      final zonesList =
          ShippingZonesListResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(zonesList);
    } catch (e) {
      return ApiErrorHandler.handleError<ShippingZonesListResponse>(e);
    }
  }

  Future<ApiResult<ShippingZoneResponse>> createShippingZone(
      CreateShippingZoneRequest request) async {
    try {
      final response = await _apiService.createShippingZone(request.toJson());
      final zone =
          ShippingZoneResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(zone);
    } catch (e) {
      return ApiErrorHandler.handleError<ShippingZoneResponse>(e);
    }
  }

  Future<ApiResult<ShippingZoneResponse>> updateShippingZone(
    String id,
    UpdateShippingZoneRequest request,
  ) async {
    try {
      final response =
          await _apiService.updateShippingZone(int.parse(id), request.toJson());
      final zone =
          ShippingZoneResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(zone);
    } catch (e) {
      return ApiErrorHandler.handleError<ShippingZoneResponse>(e);
    }
  }

  Future<ApiResult<void>> deleteShippingZone(String id) async {
    try {
      await _apiService.deleteShippingZone(int.parse(id));
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }

  Future<ApiResult<TrackingUpdatesListResponse>> getTrackingUpdates({
    String? orderId,
    int? limit,
  }) async {
    try {
      final queries = <String, dynamic>{};
      if (orderId != null && orderId.isNotEmpty) {
        queries['orderId'] = orderId;
      }
      if (limit != null) {
        queries['limit'] = limit;
      }

      final response = await _apiService.getTrackingUpdates(queries.isEmpty ? null : queries);
      final updatesList =
          TrackingUpdatesListResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(updatesList);
    } catch (e) {
      return ApiErrorHandler.handleError<TrackingUpdatesListResponse>(e);
    }
  }
}

