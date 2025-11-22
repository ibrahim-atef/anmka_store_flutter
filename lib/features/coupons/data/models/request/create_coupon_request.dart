import 'package:json_annotation/json_annotation.dart';

part 'create_coupon_request.g.dart';

@JsonSerializable()
class CreateCouponRequest {
  final String code;
  final String type; // percent, fixed, freeShipping
  final double discountValue;
  final int maxUsage;
  @JsonKey(name: 'validUntil')
  final String validUntil;

  const CreateCouponRequest({
    required this.code,
    required this.type,
    required this.discountValue,
    required this.maxUsage,
    required this.validUntil,
  });

  factory CreateCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCouponRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCouponRequestToJson(this);
}

