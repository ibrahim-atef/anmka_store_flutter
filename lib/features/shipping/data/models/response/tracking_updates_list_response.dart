import 'package:json_annotation/json_annotation.dart';
import 'tracking_update_response.dart';

part 'tracking_updates_list_response.g.dart';

@JsonSerializable()
class TrackingUpdatesListResponse {
  final List<TrackingUpdateResponse> updates;

  const TrackingUpdatesListResponse({
    required this.updates,
  });

  factory TrackingUpdatesListResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackingUpdatesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingUpdatesListResponseToJson(this);
}

