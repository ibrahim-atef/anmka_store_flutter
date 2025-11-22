// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingUpdateResponse _$TrackingUpdateResponseFromJson(
        Map<String, dynamic> json) =>
    TrackingUpdateResponse(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      status: json['status'] as String,
      time: json['time'] as String,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$TrackingUpdateResponseToJson(
        TrackingUpdateResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'status': instance.status,
      'time': instance.time,
      'location': instance.location,
      'notes': instance.notes,
    };
