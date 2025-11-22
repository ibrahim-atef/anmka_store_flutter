// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_coupon_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCouponRequest _$UpdateCouponRequestFromJson(Map<String, dynamic> json) =>
    UpdateCouponRequest(
      code: json['code'] as String?,
      type: json['type'] as String?,
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      maxUsage: (json['maxUsage'] as num?)?.toInt(),
      validUntil: json['validUntil'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UpdateCouponRequestToJson(
        UpdateCouponRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'type': instance.type,
      'discountValue': instance.discountValue,
      'maxUsage': instance.maxUsage,
      'validUntil': instance.validUntil,
      'isActive': instance.isActive,
    };
