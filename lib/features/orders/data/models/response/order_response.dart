import 'package:json_annotation/json_annotation.dart';
import 'order_item_response.dart';

part 'order_response.g.dart';

@JsonSerializable()
class OrderResponse {
  final String id;
  final String customerName;
  final String? customerId;
  final String? customerEmail;
  final String? customerPhone;
  final double total;
  final String status;
  final String paymentStatus;
  final String shippingStatus;
  final String date;
  final String? shippingAddress;
  final String? notes;
  final List<OrderItemResponse> items;

  const OrderResponse({
    required this.id,
    required this.customerName,
    this.customerId,
    this.customerEmail,
    this.customerPhone,
    required this.total,
    required this.status,
    required this.paymentStatus,
    required this.shippingStatus,
    required this.date,
    this.shippingAddress,
    this.notes,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

