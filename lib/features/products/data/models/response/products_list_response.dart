import 'package:json_annotation/json_annotation.dart';
import 'product_response.dart';

part 'products_list_response.g.dart';

@JsonSerializable()
class ProductsListResponse {
  final List<ProductResponse> products;
  final int total;
  final int page;
  final int limit;

  const ProductsListResponse({
    required this.products,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory ProductsListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsListResponseToJson(this);
}

