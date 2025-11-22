// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettingsResponse _$NotificationSettingsResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsResponse(
      notificationsEnabled: json['notificationsEnabled'] as bool,
      twoFactorEnabled: json['twoFactorEnabled'] as bool,
      autoSyncEnabled: json['autoSyncEnabled'] as bool,
    );

Map<String, dynamic> _$NotificationSettingsResponseToJson(
        NotificationSettingsResponse instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'twoFactorEnabled': instance.twoFactorEnabled,
      'autoSyncEnabled': instance.autoSyncEnabled,
    };
