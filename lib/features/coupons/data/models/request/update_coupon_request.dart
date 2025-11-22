import 'package:json_annotation/json_annotation.dart';

part 'update_coupon_request.g.dart';

@JsonSerializable()
class UpdateCouponRequest {
  final String? code;
  final String? type; // percent, fixed, freeShipping
  final double? discountValue;
  final int? maxUsage;
  @JsonKey(name: 'validUntil')
  final String? validUntil;
  final bool? isActive;

  const UpdateCouponRequest({
    this.code,
    this.type,
    this.discountValue,
    this.maxUsage,
    this.validUntil,
    this.isActive,
  });

  factory UpdateCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCouponRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCouponRequestToJson(this);
}

