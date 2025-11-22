// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupons_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponsListResponse _$CouponsListResponseFromJson(Map<String, dynamic> json) =>
    CouponsListResponse(
      coupons: (json['coupons'] as List<dynamic>)
          .map((e) => CouponResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CouponsListResponseToJson(
        CouponsListResponse instance) =>
    <String, dynamic>{
      'coupons': instance.coupons,
    };
