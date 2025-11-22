// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_shipping_zone_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateShippingZoneRequest _$UpdateShippingZoneRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateShippingZoneRequest(
      name: json['name'] as String?,
      deliveryTime: json['deliveryTime'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      coverage: json['coverage'] as String?,
    );

Map<String, dynamic> _$UpdateShippingZoneRequestToJson(
        UpdateShippingZoneRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'deliveryTime': instance.deliveryTime,
      'cost': instance.cost,
      'coverage': instance.coverage,
    };
