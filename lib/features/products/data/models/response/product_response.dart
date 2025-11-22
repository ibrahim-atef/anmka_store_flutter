import 'package:json_annotation/json_annotation.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String status;
  final String image;
  final String sku;
  final int? sales;
  final String? description;

  const ProductResponse({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.image,
    required this.sku,
    this.sales,
    this.description,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

