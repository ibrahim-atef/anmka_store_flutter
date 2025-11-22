import 'package:json_annotation/json_annotation.dart';

part 'create_shipping_zone_request.g.dart';

@JsonSerializable()
class CreateShippingZoneRequest {
  final String name;
  @JsonKey(name: 'deliveryTime')
  final String deliveryTime;
  final double cost;
  final String coverage;

  const CreateShippingZoneRequest({
    required this.name,
    required this.deliveryTime,
    required this.cost,
    required this.coverage,
  });

  factory CreateShippingZoneRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateShippingZoneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateShippingZoneRequestToJson(this);
}

