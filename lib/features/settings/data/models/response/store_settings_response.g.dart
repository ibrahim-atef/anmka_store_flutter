// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSettingsResponse _$StoreSettingsResponseFromJson(
        Map<String, dynamic> json) =>
    StoreSettingsResponse(
      storeName: json['storeName'] as String,
      storeDomain: json['storeDomain'] as String?,
      storeCategory: json['storeCategory'] as String?,
      storeUrl: json['storeUrl'] as String?,
    );

Map<String, dynamic> _$StoreSettingsResponseToJson(
        StoreSettingsResponse instance) =>
    <String, dynamic>{
      'storeName': instance.storeName,
      'storeDomain': instance.storeDomain,
      'storeCategory': instance.storeCategory,
      'storeUrl': instance.storeUrl,
    };
