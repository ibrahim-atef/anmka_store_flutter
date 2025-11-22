import 'package:json_annotation/json_annotation.dart';
import 'notification_response.dart';

part 'notifications_list_response.g.dart';

@JsonSerializable()
class NotificationsListResponse {
  final List<NotificationResponse> notifications;
  @JsonKey(name: 'unreadCount')
  final int unreadCount;

  const NotificationsListResponse({
    required this.notifications,
    required this.unreadCount,
  });

  factory NotificationsListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsListResponseToJson(this);
}

