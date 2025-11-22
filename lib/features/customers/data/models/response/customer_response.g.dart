// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerResponse _$CustomerResponseFromJson(Map<String, dynamic> json) =>
    CustomerResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      tier: json['tier'] as String?,
      totalOrders: (json['totalOrders'] as num?)?.toInt(),
      totalSpent: (json['totalSpent'] as num?)?.toDouble(),
      lastActive: json['lastActive'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$CustomerResponseToJson(CustomerResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'tier': instance.tier,
      'totalOrders': instance.totalOrders,
      'totalSpent': instance.totalSpent,
      'lastActive': instance.lastActive,
      'tags': instance.tags,
      'avatar': instance.avatar,
    };
