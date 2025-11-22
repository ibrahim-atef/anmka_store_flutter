// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsListResponse _$NotificationsListResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationsListResponse(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: (json['unreadCount'] as num).toInt(),
    );

Map<String, dynamic> _$NotificationsListResponseToJson(
        NotificationsListResponse instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'unreadCount': instance.unreadCount,
    };
