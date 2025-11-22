import 'package:json_annotation/json_annotation.dart';

part 'customer_response.g.dart';

@JsonSerializable()
class CustomerResponse {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? tier;
  final int? totalOrders;
  final double? totalSpent;
  final String? lastActive;
  final List<String>? tags;
  final String? avatar;

  const CustomerResponse({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.tier,
    this.totalOrders,
    this.totalSpent,
    this.lastActive,
    this.tags,
    this.avatar,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerResponseToJson(this);
}

