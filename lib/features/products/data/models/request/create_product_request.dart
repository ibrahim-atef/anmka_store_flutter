import 'package:json_annotation/json_annotation.dart';

part 'create_product_request.g.dart';

@JsonSerializable()
class CreateProductRequest {
  final String name;
  final String category;
  final double price;
  final int stock;
  final String sku;
  final String? description;
  final String? image;

  const CreateProductRequest({
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.sku,
    this.description,
    this.image,
  });

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProductRequestToJson(this);
}

