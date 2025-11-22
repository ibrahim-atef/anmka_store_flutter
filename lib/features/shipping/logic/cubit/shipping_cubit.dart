import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/request/create_shipping_zone_request.dart';
import '../../data/models/request/update_shipping_zone_request.dart';
import '../../data/repositories/shipping_repository.dart';
import '../../logic/states/shipping_state.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final ShippingRepository _repository;

  ShippingCubit(this._repository) : super(const ShippingState.initial());

  Future<void> getShippingZones() async {
    emit(const ShippingState.loading());

    final result = await _repository.getShippingZones();

    result.when(
      success: (zonesList) {
        // Also load tracking updates
        _loadTrackingUpdates(zonesList);
      },
      failure: (error) {
        emit(ShippingState.error(error.errorMessage));
      },
    );
  }

  Future<void> _loadTrackingUpdates(
      dynamic zonesList, {
      String? orderId,
      int? limit,
    }) async {
    final trackingResult = await _repository.getTrackingUpdates(
      orderId: orderId,
      limit: limit,
    );

    trackingResult.when(
      success: (updatesList) {
        emit(ShippingState.loaded(zonesList, updatesList));
      },
      failure: (_) {
        // If tracking fails, still show zones
        emit(ShippingState.loaded(zonesList, null));
      },
    );
  }

  Future<void> createShippingZone(CreateShippingZoneRequest request) async {
    emit(const ShippingState.loading());

    final result = await _repository.createShippingZone(request);

    result.when(
      success: (_) {
        // Reload zones
        getShippingZones();
      },
      failure: (error) {
        emit(ShippingState.error(error.errorMessage));
      },
    );
  }

  Future<void> updateShippingZone(
      String id, UpdateShippingZoneRequest request) async {
    emit(const ShippingState.loading());

    final result = await _repository.updateShippingZone(id, request);

    result.when(
      success: (_) {
        // Reload zones
        getShippingZones();
      },
      failure: (error) {
        emit(ShippingState.error(error.errorMessage));
      },
    );
  }

  Future<void> deleteShippingZone(String id) async {
    emit(const ShippingState.loading());

    final result = await _repository.deleteShippingZone(id);

    result.when(
      success: (_) {
        // Reload zones
        getShippingZones();
      },
      failure: (error) {
        emit(ShippingState.error(error.errorMessage));
      },
    );
  }
}

