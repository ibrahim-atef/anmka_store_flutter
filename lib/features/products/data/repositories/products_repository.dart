import 'package:dio/dio.dart';
import '../../../../core/network/api_error_handel.dart';
import '../../../../core/network/api_error_model.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_service.dart';
import '../models/request/create_product_request.dart';
import '../models/request/update_product_request.dart';
import '../models/response/product_response.dart';
import '../models/response/products_list_response.dart';

class ProductsRepository {
  final ApiService _apiService;

  ProductsRepository(this._apiService);

  Future<ApiResult<ProductsListResponse>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? status,
  }) async {
    try {
      final queries = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        if (status != null && status.isNotEmpty) 'status': status,
      };

      final response = await _apiService.getProducts(queries);

      // Validate response type
      if (response == null) {
        return ApiResult.failure(
          const ApiErrorModel(
            message: 'لا توجد بيانات في الاستجابة',
            code: 'NULL_RESPONSE',
            statusCode: 500,
          ),
        );
      }

      if (response is! Map<String, dynamic>) {
        return ApiResult.failure(
          ApiErrorModel(
            message: 'تنسيق الاستجابة غير صحيح: ${response.runtimeType}',
            code: 'INVALID_RESPONSE_TYPE',
            statusCode: 500,
          ),
        );
      }

      final productsList = ProductsListResponse.fromJson(response);
      return ApiResult.success(productsList);
    } on DioException catch (e) {
      return ApiErrorHandler.handleError<ProductsListResponse>(e);
    } catch (e) {
      // Handle parsing errors or other exceptions
      return ApiErrorHandler.handleError<ProductsListResponse>(e);
    }
  }

  Future<ApiResult<ProductResponse>> getProductById(int id) async {
    try {
      final response = await _apiService.getProductById(id);
      final product =
          ProductResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(product);
    } catch (e) {
      return ApiErrorHandler.handleError<ProductResponse>(e);
    }
  }

  Future<ApiResult<ProductResponse>> createProduct(
      CreateProductRequest request) async {
    try {
      final response = await _apiService.createProduct(request.toJson());
      final product =
          ProductResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(product);
    } catch (e) {
      return ApiErrorHandler.handleError<ProductResponse>(e);
    }
  }

  Future<ApiResult<ProductResponse>> updateProduct(
    int id,
    UpdateProductRequest request,
  ) async {
    try {
      final response = await _apiService.updateProduct(id, request.toJson());
      final product =
          ProductResponse.fromJson(response as Map<String, dynamic>);
      return ApiResult.success(product);
    } catch (e) {
      return ApiErrorHandler.handleError<ProductResponse>(e);
    }
  }

  Future<ApiResult<void>> deleteProduct(int id) async {
    try {
      // The API returns {"message": "Product deleted successfully"} on success with 200 status
      // We don't need to parse the response, just verify no exception was thrown
      // Any response with 200 status code means success
      await _apiService.deleteProduct(id);
      return ApiResult.success(null);
    } on DioException catch (e) {
      // Only handle DioException (network/API errors)
      return ApiErrorHandler.handleError<void>(e);
    } catch (e) {
      // Handle any other unexpected errors
      return ApiErrorHandler.handleError<void>(e);
    }
  }
}
