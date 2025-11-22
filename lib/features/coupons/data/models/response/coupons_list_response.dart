import 'package:json_annotation/json_annotation.dart';
import 'coupon_response.dart';

part 'coupons_list_response.g.dart';

@JsonSerializable()
class CouponsListResponse {
  final List<CouponResponse> coupons;

  const CouponsListResponse({
    required this.coupons,
  });

  factory CouponsListResponse.fromJson(Map<String, dynamic> json) =>
      _$CouponsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CouponsListResponseToJson(this);
}

