import 'package:json_annotation/json_annotation.dart';
import 'customer_response.dart';

part 'customers_list_response.g.dart';

@JsonSerializable()
class CustomersListResponse {
  final List<CustomerResponse> customers;
  final int total;
  final int page;
  final int limit;

  const CustomersListResponse({
    required this.customers,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory CustomersListResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomersListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomersListResponseToJson(this);
}

