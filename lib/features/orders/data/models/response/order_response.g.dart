// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerId: json['customerId'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      shippingStatus: json['shippingStatus'] as String,
      date: json['date'] as String,
      shippingAddress: json['shippingAddress'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'customerId': instance.customerId,
      'customerEmail': instance.customerEmail,
      'customerPhone': instance.customerPhone,
      'total': instance.total,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'shippingStatus': instance.shippingStatus,
      'date': instance.date,
      'shippingAddress': instance.shippingAddress,
      'notes': instance.notes,
      'items': instance.items,
    };
