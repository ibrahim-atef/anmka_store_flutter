import 'package:json_annotation/json_annotation.dart';
import 'shipping_zone_response.dart';

part 'shipping_zones_list_response.g.dart';

@JsonSerializable()
class ShippingZonesListResponse {
  final List<ShippingZoneResponse> zones;

  const ShippingZonesListResponse({
    required this.zones,
  });

  factory ShippingZonesListResponse.fromJson(Map<String, dynamic> json) =>
      _$ShippingZonesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingZonesListResponseToJson(this);
}

