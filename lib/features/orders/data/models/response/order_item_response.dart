import 'package:json_annotation/json_annotation.dart';

part 'order_item_response.g.dart';

@JsonSerializable()
class OrderItemResponse {
  final int? productId;
  final String? name;
  final int quantity;
  final double price;

  const OrderItemResponse({
    this.productId,
    this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemResponseToJson(this);
}

