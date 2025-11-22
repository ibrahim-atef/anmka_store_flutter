import 'package:json_annotation/json_annotation.dart';

part 'tracking_update_response.g.dart';

@JsonSerializable()
class TrackingUpdateResponse {
  final String id;
  @JsonKey(name: 'orderId')
  final String orderId;
  final String status;
  final String time;
  final String? location;
  final String? notes;

  const TrackingUpdateResponse({
    required this.id,
    required this.orderId,
    required this.status,
    required this.time,
    this.location,
    this.notes,
  });

  factory TrackingUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackingUpdateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingUpdateResponseToJson(this);
}

