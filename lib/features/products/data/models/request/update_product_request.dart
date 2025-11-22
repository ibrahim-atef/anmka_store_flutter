import 'package:json_annotation/json_annotation.dart';

part 'update_product_request.g.dart';

@JsonSerializable()
class UpdateProductRequest {
  final String? name;
  final double? price;
  final int? stock;
  final String? category;
  final String? description;
  final String? image;

  const UpdateProductRequest({
    this.name,
    this.price,
    this.stock,
    this.category,
    this.description,
    this.image,
  });

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProductRequestToJson(this);
}

