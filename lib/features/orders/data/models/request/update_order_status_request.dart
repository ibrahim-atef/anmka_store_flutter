import 'package:json_annotation/json_annotation.dart';

part 'update_order_status_request.g.dart';

@JsonSerializable()
class UpdateOrderStatusRequest {
  final String status;

  const UpdateOrderStatusRequest({required this.status});

  factory UpdateOrderStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStatusRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderStatusRequestToJson(this);
}

