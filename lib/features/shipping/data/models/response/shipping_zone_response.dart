import 'package:json_annotation/json_annotation.dart';

part 'shipping_zone_response.g.dart';

@JsonSerializable()
class ShippingZoneResponse {
  final String id;
  final String name;
  @JsonKey(name: 'deliveryTime')
  final String deliveryTime;
  final double cost;
  final String coverage;

  const ShippingZoneResponse({
    required this.id,
    required this.name,
    required this.deliveryTime,
    required this.cost,
    required this.coverage,
  });

  factory ShippingZoneResponse.fromJson(Map<String, dynamic> json) =>
      _$ShippingZoneResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingZoneResponseToJson(this);
}

