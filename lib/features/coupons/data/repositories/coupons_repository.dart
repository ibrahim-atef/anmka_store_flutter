import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/request/create_coupon_request.dart';
import '../models/request/update_coupon_request.dart';
import '../models/response/coupon_response.dart';
import '../models/response/coupons_list_response.dart';

class CouponsRepository {
  final ApiService _apiService;

  CouponsRepository(this._apiService);

  Future<ApiResult<CouponsListResponse>> getCoupons() async {
    try {
      final response = await _apiService.getCoupons();
      final couponsList =
          CouponsListResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(couponsList);
    } catch (e) {
      return ApiErrorHandler.handleError<CouponsListResponse>(e);
    }
  }

  Future<ApiResult<CouponResponse>> createCoupon(
      CreateCouponRequest request) async {
    try {
      final response = await _apiService.createCoupon(request.toJson());
      final coupon =
          CouponResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(coupon);
    } catch (e) {
      return ApiErrorHandler.handleError<CouponResponse>(e);
    }
  }

  Future<ApiResult<CouponResponse>> updateCoupon(
    String id,
    UpdateCouponRequest request,
  ) async {
    try {
      final response =
          await _apiService.updateCoupon(int.parse(id), request.toJson());
      final coupon =
          CouponResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(coupon);
    } catch (e) {
      return ApiErrorHandler.handleError<CouponResponse>(e);
    }
  }

  Future<ApiResult<void>> deleteCoupon(String id) async {
    try {
      await _apiService.deleteCoupon(int.parse(id));
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }
}

