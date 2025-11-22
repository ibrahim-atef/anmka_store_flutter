import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/response/customer_response.dart';
import '../models/response/customers_list_response.dart';

class CustomersRepository {
  final ApiService _apiService;

  CustomersRepository(this._apiService);

  Future<ApiResult<CustomersListResponse>> getCustomers({
    int page = 1,
    int limit = 20,
    String? tier,
    String? search,
  }) async {
    try {
      final queries = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (tier != null && tier.isNotEmpty) 'tier': tier,
        if (search != null && search.isNotEmpty) 'search': search,
      };
      
      final response = await _apiService.getCustomers(queries);
      final customersList = CustomersListResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(customersList);
    } catch (e) {
      return ApiErrorHandler.handleError<CustomersListResponse>(e);
    }
  }

  Future<ApiResult<CustomerResponse>> getCustomerById(int id) async {
    try {
      final response = await _apiService.getCustomerById(id);
      final customer = CustomerResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(customer);
    } catch (e) {
      return ApiErrorHandler.handleError<CustomerResponse>(e);
    }
  }
}

