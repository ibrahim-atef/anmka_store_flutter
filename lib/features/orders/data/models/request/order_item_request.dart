import 'package:json_annotation/json_annotation.dart';

part 'order_item_request.g.dart';

@JsonSerializable()
class OrderItemRequest {
  final int productId;
  final int quantity;

  const OrderItemRequest({
    required this.productId,
    required this.quantity,
  });

  factory OrderItemRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemRequestToJson(this);
}

