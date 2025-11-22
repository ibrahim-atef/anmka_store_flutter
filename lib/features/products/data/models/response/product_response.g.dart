// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      status: json['status'] as String,
      image: json['image'] as String,
      sku: json['sku'] as String,
      sales: (json['sales'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'price': instance.price,
      'stock': instance.stock,
      'status': instance.status,
      'image': instance.image,
      'sku': instance.sku,
      'sales': instance.sales,
      'description': instance.description,
    };
