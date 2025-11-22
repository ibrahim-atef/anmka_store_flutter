import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/request/create_product_request.dart';
import '../../data/models/request/update_product_request.dart';
import '../../data/repositories/products_repository.dart';
import '../../logic/states/products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit(this._repository) : super(const ProductsState.initial());

  Future<void> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? status,
  }) async {
    emit(const ProductsState.loading());

    final result = await _repository.getProducts(
      page: page,
      limit: limit,
      search: search,
      category: category,
      status: status,
    );

    result.when(
      success: (productsList) {
        emit(ProductsState.loaded(productsList));
      },
      failure: (error) {
        emit(ProductsState.error(error.errorMessage));
      },
    );
  }

  Future<void> getProductById(int id) async {
    emit(const ProductsState.loading());

    final result = await _repository.getProductById(id);

    result.when(
      success: (product) {
        emit(ProductsState.productLoaded(product));
      },
      failure: (error) {
        emit(ProductsState.error(error.errorMessage));
      },
    );
  }

  Future<void> createProduct(CreateProductRequest request) async {
    emit(const ProductsState.loading());

    final result = await _repository.createProduct(request);

    result.when(
      success: (_) {
        // Reload products list
        getProducts();
      },
      failure: (error) {
        emit(ProductsState.error(error.errorMessage));
      },
    );
  }

  Future<void> updateProduct(int id, UpdateProductRequest request) async {
    emit(const ProductsState.loading());

    final result = await _repository.updateProduct(id, request);

    result.when(
      success: (_) {
        // Reload products list
        getProducts();
      },
      failure: (error) {
        emit(ProductsState.error(error.errorMessage));
      },
    );
  }

  Future<void> deleteProduct(int id) async {
    // Don't emit loading state for delete to avoid UI flicker
    // We'll only show loading when refreshing the list

    final result = await _repository.deleteProduct(id);

    result.when(
      success: (_) {
        // Reload products list - this will emit loading state
        // If getProducts fails, it will handle its own error state
        // The deletion itself was successful, so we don't show error for that
        getProducts();
      },
      failure: (error) {
        // Only show error if the deletion itself failed
        emit(ProductsState.error(error.errorMessage));
      },
    );
  }
}
