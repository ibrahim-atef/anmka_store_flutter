// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_notification_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateNotificationSettingsRequest _$UpdateNotificationSettingsRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateNotificationSettingsRequest(
      notificationsEnabled: json['notificationsEnabled'] as bool?,
      twoFactorEnabled: json['twoFactorEnabled'] as bool?,
      autoSyncEnabled: json['autoSyncEnabled'] as bool?,
    );

Map<String, dynamic> _$UpdateNotificationSettingsRequestToJson(
        UpdateNotificationSettingsRequest instance) =>
    <String, dynamic>{
      'notificationsEnabled': instance.notificationsEnabled,
      'twoFactorEnabled': instance.twoFactorEnabled,
      'autoSyncEnabled': instance.autoSyncEnabled,
    };
