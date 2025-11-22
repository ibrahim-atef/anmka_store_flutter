// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_store_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStoreSettingsRequest _$UpdateStoreSettingsRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateStoreSettingsRequest(
      storeName: json['storeName'] as String?,
      storeCategory: json['storeCategory'] as String?,
      storeUrl: json['storeUrl'] as String?,
    );

Map<String, dynamic> _$UpdateStoreSettingsRequestToJson(
        UpdateStoreSettingsRequest instance) =>
    <String, dynamic>{
      'storeName': instance.storeName,
      'storeCategory': instance.storeCategory,
      'storeUrl': instance.storeUrl,
    };
