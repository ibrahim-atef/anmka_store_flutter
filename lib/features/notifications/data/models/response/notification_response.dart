import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse {
  final String id;
  final String title;
  final String description;
  final String category;
  @JsonKey(name: 'time')
  final String time;
  @JsonKey(name: 'isRead')
  final bool isRead;
  final String? tone; // success, info, warning, danger

  const NotificationResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.time,
    required this.isRead,
    this.tone,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}

