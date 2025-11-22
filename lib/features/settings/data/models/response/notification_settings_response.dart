import 'package:json_annotation/json_annotation.dart';

part 'notification_settings_response.g.dart';

@JsonSerializable()
class NotificationSettingsResponse {
  @JsonKey(name: 'notificationsEnabled')
  final bool notificationsEnabled;
  @JsonKey(name: 'twoFactorEnabled')
  final bool twoFactorEnabled;
  @JsonKey(name: 'autoSyncEnabled')
  final bool autoSyncEnabled;

  const NotificationSettingsResponse({
    required this.notificationsEnabled,
    required this.twoFactorEnabled,
    required this.autoSyncEnabled,
  });

  factory NotificationSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsResponseToJson(this);
}

