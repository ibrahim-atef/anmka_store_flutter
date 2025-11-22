// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_zone_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingZoneResponse _$ShippingZoneResponseFromJson(
        Map<String, dynamic> json) =>
    ShippingZoneResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      deliveryTime: json['deliveryTime'] as String,
      cost: (json['cost'] as num).toDouble(),
      coverage: json['coverage'] as String,
    );

Map<String, dynamic> _$ShippingZoneResponseToJson(
        ShippingZoneResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'deliveryTime': instance.deliveryTime,
      'cost': instance.cost,
      'coverage': instance.coverage,
    };
