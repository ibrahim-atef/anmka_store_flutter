import 'package:json_annotation/json_annotation.dart';
import 'order_response.dart';

part 'orders_list_response.g.dart';

@JsonSerializable()
class OrdersListResponse {
  final List<OrderResponse> orders;
  final int total;
  final int page;
  final int limit;

  const OrdersListResponse({
    required this.orders,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersListResponseToJson(this);
}

