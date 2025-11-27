import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response/dashboard_stats_response.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../domain/entities/dashboard_models.dart';
import '../../logic/states/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState.initial());

  final DashboardRepository _repository;
  DashboardSalesPeriod _currentPeriod = DashboardSalesPeriod.daily;

  Future<void> loadDashboard({DashboardSalesPeriod? period}) async {
    final targetPeriod = period ?? _currentPeriod;
    _currentPeriod = targetPeriod;

    emit(const DashboardState.loading());

    final stats = await _fetchStats();
    if (stats == null) return;

    final sales = await _fetchSales(targetPeriod);
    if (sales == null) return;

    final topProducts = await _fetchTopProducts();
    if (topProducts == null) return;

    final trafficSources = await _fetchTrafficSources();
    if (trafficSources == null) return;

    final recentActivities = await _fetchRecentActivities();
    if (recentActivities == null) return;

    emit(
      DashboardState.loaded(
        stats: stats,
        sales: sales,
        period: targetPeriod,
        topProducts: topProducts,
        trafficSources: trafficSources,
        activities: recentActivities,
      ),
    );
  }

  Future<void> refresh() => loadDashboard(period: _currentPeriod);

  Future<void> changePeriod(DashboardSalesPeriod period) {
    return state.when<Future<void>>(
      initial: () => loadDashboard(period: period),
      loading: () async {},
      error: (_) => loadDashboard(period: period),
      loaded: (stats, sales, currentPeriod, topProducts, trafficSources,
          activities, isSalesLoading) async {
        if (currentPeriod == period) return;

        _currentPeriod = period;

        emit(
          DashboardState.loaded(
            stats: stats,
            sales: sales,
            period: period,
            topProducts: topProducts,
            trafficSources: trafficSources,
            activities: activities,
            isSalesLoading: true,
          ),
        );

        final newSales = await _fetchSales(period);
        if (newSales == null) return;

        emit(
          DashboardState.loaded(
            stats: stats,
            sales: newSales,
            period: period,
            topProducts: topProducts,
            trafficSources: trafficSources,
            activities: activities,
          ),
        );
      },
    );
  }

  Future<DashboardStatsResponse?> _fetchStats() async {
    final result = await _repository.getStats();
    DashboardStatsResponse? stats;
    result.when(
      success: (data) => stats = data,
      failure: (error) => emit(DashboardState.error(error.errorMessage)),
    );
    return stats;
  }

  Future<List<DashboardSalesPoint>?> _fetchSales(
      DashboardSalesPeriod period) async {
    final result = await _repository.getSales(period: period.apiValue);
    List<DashboardSalesPoint>? sales;
    result.when(
      success: (data) => sales = _mapSales(data),
      failure: (error) => emit(DashboardState.error(error.errorMessage)),
    );
    return sales;
  }

  Future<List<DashboardTopProduct>?> _fetchTopProducts() async {
    final result = await _repository.getTopProducts(limit: 5, period: 'week');
    List<DashboardTopProduct>? products;
    result.when(
      success: (data) => products = _mapTopProducts(data),
      failure: (error) => emit(DashboardState.error(error.errorMessage)),
    );
    return products;
  }

  Future<List<DashboardTrafficSourceEntry>?> _fetchTrafficSources() async {
    final result = await _repository.getTrafficSources();
    List<DashboardTrafficSourceEntry>? sources;
    result.when(
      success: (data) => sources = _mapTrafficSources(data),
      failure: (error) => emit(DashboardState.error(error.errorMessage)),
    );
    return sources;
  }

  Future<List<DashboardActivityEntry>?> _fetchRecentActivities() async {
    final result = await _repository.getRecentActivities(limit: 10);
    List<DashboardActivityEntry>? activities;
    result.when(
      success: (data) => activities = _mapActivities(data),
      failure: (error) => emit(DashboardState.error(error.errorMessage)),
    );
    return activities;
  }

  List<DashboardSalesPoint> _mapSales(dynamic response) {
    final list = _extractList(response, 'data');
    return list
        .map(
          (item) => DashboardSalesPoint(
            label: item['label']?.toString() ?? '',
            sales: _asDouble(item['sales']),
            orders: _asInt(item['orders']),
          ),
        )
        .toList();
  }

  List<DashboardTopProduct> _mapTopProducts(dynamic response) {
    final list = _extractList(response, 'products');
    return list
        .map(
          (item) => DashboardTopProduct(
            id: _asInt(item['id']),
            name: item['name']?.toString() ?? 'منتج غير معروف',
            price: _asDouble(item['price']),
            sales: _asInt(item['sales']),
            image: item['image']?.toString(),
          ),
        )
        .toList();
  }

  List<DashboardTrafficSourceEntry> _mapTrafficSources(dynamic response) {
    final list =
        _extractList(response, 'sources', fallbackKey: 'data', allowRootList: true);
    return list
        .map(
          (item) => DashboardTrafficSourceEntry(
            name: item['name']?.toString() ?? 'غير معروف',
            value: _asDouble(item['value']),
            percentage: _asDouble(item['percentage']),
          ),
        )
        .toList();
  }

  List<DashboardActivityEntry> _mapActivities(dynamic response) {
    final list =
        _extractList(response, 'activities', fallbackKey: 'data', allowRootList: true);
    return list
        .map(
          (item) => DashboardActivityEntry(
            title: item['title']?.toString() ??
                item['type']?.toString() ??
                'نشاط',
            subtitle: item['subtitle']?.toString() ??
                item['description']?.toString() ??
                '',
            tag: item['tag']?.toString() ??
                item['status']?.toString() ??
                'جديد',
            tagTone: item['tagTone']?.toString() ??
                item['tone']?.toString() ??
                'info',
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _extractList(
    dynamic response,
    String primaryKey, {
    String? fallbackKey,
    bool allowRootList = false,
  }) {
    if (response is List && allowRootList) {
      return response
          .whereType<Map<dynamic, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (response is Map<String, dynamic>) {
      final primary = response[primaryKey];
      if (primary is List) {
        return primary
            .whereType<Map<dynamic, dynamic>>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      if (fallbackKey != null && response[fallbackKey] is List) {
        return (response[fallbackKey] as List)
            .whereType<Map<dynamic, dynamic>>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    if (response is List && !allowRootList) {
      return response
          .whereType<Map<dynamic, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return const [];
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
