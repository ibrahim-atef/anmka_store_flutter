import 'package:json_annotation/json_annotation.dart';

part 'coupon_response.g.dart';

@JsonSerializable()
class CouponResponse {
  final String id;
  final String code;
  final String type; // percent, fixed, freeShipping
  final double discountValue;
  final String discountLabel;
  final int usage;
  final int maxUsage;
  @JsonKey(name: 'validUntil')
  final String validUntil;
  final bool isActive;

  const CouponResponse({
    required this.id,
    required this.code,
    required this.type,
    required this.discountValue,
    required this.discountLabel,
    required this.usage,
    required this.maxUsage,
    required this.validUntil,
    required this.isActive,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) =>
      _$CouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CouponResponseToJson(this);
}

