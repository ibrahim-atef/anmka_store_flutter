// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_shipping_zone_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateShippingZoneRequest _$CreateShippingZoneRequestFromJson(
        Map<String, dynamic> json) =>
    CreateShippingZoneRequest(
      name: json['name'] as String,
      deliveryTime: json['deliveryTime'] as String,
      cost: (json['cost'] as num).toDouble(),
      coverage: json['coverage'] as String,
    );

Map<String, dynamic> _$CreateShippingZoneRequestToJson(
        CreateShippingZoneRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'deliveryTime': instance.deliveryTime,
      'cost': instance.cost,
      'coverage': instance.coverage,
    };
