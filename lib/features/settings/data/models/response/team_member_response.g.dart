// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMemberResponse _$TeamMemberResponseFromJson(Map<String, dynamic> json) =>
    TeamMemberResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$TeamMemberResponseToJson(TeamMemberResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };
