import 'package:json_annotation/json_annotation.dart';

part 'invite_team_member_request.g.dart';

@JsonSerializable()
class InviteTeamMemberRequest {
  final String name;
  final String email;
  final String role;

  const InviteTeamMemberRequest({
    required this.name,
    required this.email,
    required this.role,
  });

  factory InviteTeamMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$InviteTeamMemberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InviteTeamMemberRequestToJson(this);
}

