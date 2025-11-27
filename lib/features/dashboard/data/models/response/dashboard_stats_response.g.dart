// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsResponse _$DashboardStatsResponseFromJson(
        Map<String, dynamic> json) =>
    DashboardStatsResponse(
      totalSales: (json['totalSales'] as num?)?.toDouble(),
      totalOrders: (json['totalOrders'] as num?)?.toInt(),
      totalProducts: (json['totalProducts'] as num?)?.toInt(),
      totalCustomers: (json['totalCustomers'] as num?)?.toInt(),
      revenue: (json['revenue'] as num?)?.toDouble(),
      growth: (json['growth'] as num?)?.toDouble(),
      newOrders: (json['newOrders'] as num?)?.toInt(),
      newCustomers: (json['newCustomers'] as num?)?.toInt(),
      outOfStockProducts: (json['outOfStockProducts'] as num?)?.toInt(),
      todayVisits: (json['todayVisits'] as num?)?.toInt(),
      salesChange: (json['salesChange'] as num?)?.toDouble(),
      ordersChange: (json['ordersChange'] as num?)?.toDouble(),
      customersChange: (json['customersChange'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DashboardStatsResponseToJson(
        DashboardStatsResponse instance) =>
    <String, dynamic>{
      'totalSales': instance.totalSales,
      'totalOrders': instance.totalOrders,
      'totalProducts': instance.totalProducts,
      'totalCustomers': instance.totalCustomers,
      'revenue': instance.revenue,
      'growth': instance.growth,
      'newOrders': instance.newOrders,
      'newCustomers': instance.newCustomers,
      'outOfStockProducts': instance.outOfStockProducts,
      'todayVisits': instance.todayVisits,
      'salesChange': instance.salesChange,
      'ordersChange': instance.ordersChange,
      'customersChange': instance.customersChange,
    };
