import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/dashboard_stats_response.dart';
import '../../domain/entities/dashboard_models.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded({
    required DashboardStatsResponse stats,
    required List<DashboardSalesPoint> sales,
    required DashboardSalesPeriod period,
    required List<DashboardTopProduct> topProducts,
    required List<DashboardTrafficSourceEntry> trafficSources,
    required List<DashboardActivityEntry> activities,
    @Default(false) bool isSalesLoading,
  }) = _Loaded;
  const factory DashboardState.error(String message) = _Error;
}

