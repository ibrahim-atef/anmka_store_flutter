import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/shipping_zones_list_response.dart';
import '../../data/models/response/tracking_updates_list_response.dart';

part 'shipping_state.freezed.dart';

@freezed
class ShippingState with _$ShippingState {
  const factory ShippingState.initial() = _Initial;
  const factory ShippingState.loading() = _Loading;
  const factory ShippingState.loaded(
    ShippingZonesListResponse zonesList,
    TrackingUpdatesListResponse? trackingUpdates,
  ) = _Loaded;
  const factory ShippingState.error(String message) = _Error;
}

