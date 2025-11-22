import 'package:json_annotation/json_annotation.dart';

part 'team_member_response.g.dart';

@JsonSerializable()
class TeamMemberResponse {
  final String id;
  final String name;
  final String email;
  final String role;

  const TeamMemberResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory TeamMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMemberResponseToJson(this);
}

