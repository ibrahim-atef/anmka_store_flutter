import 'package:json_annotation/json_annotation.dart';

part 'update_notification_settings_request.g.dart';

@JsonSerializable()
class UpdateNotificationSettingsRequest {
  @JsonKey(name: 'notificationsEnabled')
  final bool? notificationsEnabled;
  @JsonKey(name: 'twoFactorEnabled')
  final bool? twoFactorEnabled;
  @JsonKey(name: 'autoSyncEnabled')
  final bool? autoSyncEnabled;

  const UpdateNotificationSettingsRequest({
    this.notificationsEnabled,
    this.twoFactorEnabled,
    this.autoSyncEnabled,
  });

  factory UpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationSettingsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNotificationSettingsRequestToJson(this);
}

