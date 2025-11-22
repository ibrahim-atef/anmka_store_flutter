import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/dashboard_stats_response.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded(DashboardStatsResponse stats) = _Loaded;
  const factory DashboardState.error(String message) = _Error;
}

