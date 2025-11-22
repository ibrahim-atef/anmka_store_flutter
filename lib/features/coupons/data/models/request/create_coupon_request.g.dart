// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_coupon_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCouponRequest _$CreateCouponRequestFromJson(Map<String, dynamic> json) =>
    CreateCouponRequest(
      code: json['code'] as String,
      type: json['type'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      maxUsage: (json['maxUsage'] as num).toInt(),
      validUntil: json['validUntil'] as String,
    );

Map<String, dynamic> _$CreateCouponRequestToJson(
        CreateCouponRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'type': instance.type,
      'discountValue': instance.discountValue,
      'maxUsage': instance.maxUsage,
      'validUntil': instance.validUntil,
    };
