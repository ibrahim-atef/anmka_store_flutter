// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersListResponse _$OrdersListResponseFromJson(Map<String, dynamic> json) =>
    OrdersListResponse(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$OrdersListResponseToJson(OrdersListResponse instance) =>
    <String, dynamic>{
      'orders': instance.orders,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
