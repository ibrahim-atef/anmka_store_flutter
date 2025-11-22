import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/product_response.dart';
import '../../data/models/response/products_list_response.dart';

part 'products_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = _Initial;
  const factory ProductsState.loading() = _Loading;
  const factory ProductsState.loaded(ProductsListResponse productsList) = _Loaded;
  const factory ProductsState.productLoaded(ProductResponse product) = _ProductLoaded;
  const factory ProductsState.error(String message) = _Error;
}

