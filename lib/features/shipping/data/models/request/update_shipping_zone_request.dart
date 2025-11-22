import 'package:json_annotation/json_annotation.dart';

part 'update_shipping_zone_request.g.dart';

@JsonSerializable()
class UpdateShippingZoneRequest {
  final String? name;
  @JsonKey(name: 'deliveryTime')
  final String? deliveryTime;
  final double? cost;
  final String? coverage;

  const UpdateShippingZoneRequest({
    this.name,
    this.deliveryTime,
    this.cost,
    this.coverage,
  });

  factory UpdateShippingZoneRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateShippingZoneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateShippingZoneRequestToJson(this);
}

