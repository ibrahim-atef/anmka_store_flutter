// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_updates_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingUpdatesListResponse _$TrackingUpdatesListResponseFromJson(
        Map<String, dynamic> json) =>
    TrackingUpdatesListResponse(
      updates: (json['updates'] as List<dynamic>)
          .map(
              (e) => TrackingUpdateResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrackingUpdatesListResponseToJson(
        TrackingUpdatesListResponse instance) =>
    <String, dynamic>{
      'updates': instance.updates,
    };
