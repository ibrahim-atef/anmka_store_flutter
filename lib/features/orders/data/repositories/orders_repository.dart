import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/request/create_order_request.dart';
import '../models/request/update_order_status_request.dart';
import '../models/response/order_response.dart';
import '../models/response/orders_list_response.dart';

class OrdersRepository {
  final ApiService _apiService;

  OrdersRepository(this._apiService);

  Future<ApiResult<OrdersListResponse>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? paymentStatus,
    String? shippingStatus,
  }) async {
    try {
      final queries = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null && status.isNotEmpty) 'status': status,
        if (paymentStatus != null && paymentStatus.isNotEmpty)
          'paymentStatus': paymentStatus,
        if (shippingStatus != null && shippingStatus.isNotEmpty)
          'shippingStatus': shippingStatus,
      };

      final response = await _apiService.getOrders(queries);
      final ordersList =
          OrdersListResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(ordersList);
    } catch (e) {
      return ApiErrorHandler.handleError<OrdersListResponse>(e);
    }
  }

  Future<ApiResult<OrderResponse>> getOrderById(String id) async {
    try {
      final response = await _apiService.getOrderById(int.parse(id));
      final order = OrderResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(order);
    } catch (e) {
      return ApiErrorHandler.handleError<OrderResponse>(e);
    }
  }

  Future<ApiResult<OrderResponse>> createOrder(
      CreateOrderRequest request) async {
    try {
      final response = await _apiService.createOrder(request.toJson());
      final order = OrderResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(order);
    } catch (e) {
      return ApiErrorHandler.handleError<OrderResponse>(e);
    }
  }

  Future<ApiResult<void>> updateOrderStatus(String id, String status) async {
    try {
      final request = UpdateOrderStatusRequest(status: status);
      await _apiService.updateOrderStatus(int.parse(id), request.toJson());
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }

  Future<ApiResult<void>> updatePaymentStatus(
      String id, String paymentStatus) async {
    try {
      await _apiService
          .updatePaymentStatus(int.parse(id), {'paymentStatus': paymentStatus});
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }

  Future<ApiResult<void>> updateShippingStatus(
      String id, String shippingStatus) async {
    try {
      await _apiService
          .updateShippingStatus(int.parse(id), {'shippingStatus': shippingStatus});
      return ApiResult.success(null);
    } catch (e) {
      return ApiErrorHandler.handleError<void>(e);
    }
  }
}
