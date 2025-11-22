// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_zones_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingZonesListResponse _$ShippingZonesListResponseFromJson(
        Map<String, dynamic> json) =>
    ShippingZonesListResponse(
      zones: (json['zones'] as List<dynamic>)
          .map((e) => ShippingZoneResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShippingZonesListResponseToJson(
        ShippingZonesListResponse instance) =>
    <String, dynamic>{
      'zones': instance.zones,
    };
