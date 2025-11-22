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
    };
