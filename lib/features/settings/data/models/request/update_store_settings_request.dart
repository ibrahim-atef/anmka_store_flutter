import 'package:json_annotation/json_annotation.dart';

part 'update_store_settings_request.g.dart';

@JsonSerializable()
class UpdateStoreSettingsRequest {
  @JsonKey(name: 'storeName')
  final String? storeName;
  @JsonKey(name: 'storeCategory')
  final String? storeCategory;
  @JsonKey(name: 'storeUrl')
  final String? storeUrl;

  const UpdateStoreSettingsRequest({
    this.storeName,
    this.storeCategory,
    this.storeUrl,
  });

  factory UpdateStoreSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateStoreSettingsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateStoreSettingsRequestToJson(this);
}

