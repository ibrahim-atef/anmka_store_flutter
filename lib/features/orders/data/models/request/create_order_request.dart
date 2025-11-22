import 'package:json_annotation/json_annotation.dart';
import 'order_item_request.dart';

part 'create_order_request.g.dart';

@JsonSerializable()
class CreateOrderRequest {
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final List<OrderItemRequest> items;
  final String shippingAddress;
  final String? notes;

  const CreateOrderRequest({
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.items,
    required this.shippingAddress,
    this.notes,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

