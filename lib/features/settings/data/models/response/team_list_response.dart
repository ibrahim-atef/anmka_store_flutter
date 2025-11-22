import 'package:json_annotation/json_annotation.dart';
import 'team_member_response.dart';

part 'team_list_response.g.dart';

@JsonSerializable()
class TeamListResponse {
  final List<TeamMemberResponse> members;

  const TeamListResponse({
    required this.members,
  });

  factory TeamListResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TeamListResponseToJson(this);
}

