// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_team_member_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteTeamMemberRequest _$InviteTeamMemberRequestFromJson(
        Map<String, dynamic> json) =>
    InviteTeamMemberRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$InviteTeamMemberRequestToJson(
        InviteTeamMemberRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };
