import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_response.g.dart';

@JsonSerializable()
class DashboardStatsResponse {
  final double? totalSales;
  final int? totalOrders;
  final int? totalProducts;
  final int? totalCustomers;
  final double? revenue;
  final double? growth;
  final int? newOrders;
  final int? newCustomers;
  final int? outOfStockProducts;
  final int? todayVisits;
  final double? salesChange;
  final double? ordersChange;
  final double? customersChange;

  const DashboardStatsResponse({
    this.totalSales,
    this.totalOrders,
    this.totalProducts,
    this.totalCustomers,
    this.revenue,
    this.growth,
    this.newOrders,
    this.newCustomers,
    this.outOfStockProducts,
    this.todayVisits,
    this.salesChange,
    this.ordersChange,
    this.customersChange,
  });

  factory DashboardStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsResponseToJson(this);
}

