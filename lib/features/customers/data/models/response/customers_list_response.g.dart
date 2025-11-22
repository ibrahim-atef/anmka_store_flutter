// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomersListResponse _$CustomersListResponseFromJson(
        Map<String, dynamic> json) =>
    CustomersListResponse(
      customers: (json['customers'] as List<dynamic>)
          .map((e) => CustomerResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$CustomersListResponseToJson(
        CustomersListResponse instance) =>
    <String, dynamic>{
      'customers': instance.customers,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
