// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsListResponse _$ProductsListResponseFromJson(
        Map<String, dynamic> json) =>
    ProductsListResponse(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$ProductsListResponseToJson(
        ProductsListResponse instance) =>
    <String, dynamic>{
      'products': instance.products,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
