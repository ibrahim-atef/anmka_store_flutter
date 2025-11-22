import 'package:json_annotation/json_annotation.dart';

part 'store_settings_response.g.dart';

@JsonSerializable()
class StoreSettingsResponse {
  @JsonKey(name: 'storeName')
  final String storeName;
  @JsonKey(name: 'storeDomain')
  final String? storeDomain;
  @JsonKey(name: 'storeCategory')
  final String? storeCategory;
  @JsonKey(name: 'storeUrl')
  final String? storeUrl;

  const StoreSettingsResponse({
    required this.storeName,
    this.storeDomain,
    this.storeCategory,
    this.storeUrl,
  });

  factory StoreSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoreSettingsResponseToJson(this);
}

