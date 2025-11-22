// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponResponse _$CouponResponseFromJson(Map<String, dynamic> json) =>
    CouponResponse(
      id: json['id'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      discountLabel: json['discountLabel'] as String,
      usage: (json['usage'] as num).toInt(),
      maxUsage: (json['maxUsage'] as num).toInt(),
      validUntil: json['validUntil'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$CouponResponseToJson(CouponResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'type': instance.type,
      'discountValue': instance.discountValue,
      'discountLabel': instance.discountLabel,
      'usage': instance.usage,
      'maxUsage': instance.maxUsage,
      'validUntil': instance.validUntil,
      'isActive': instance.isActive,
    };
