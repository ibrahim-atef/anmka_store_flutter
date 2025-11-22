import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/request/create_coupon_request.dart';
import '../../data/models/request/update_coupon_request.dart';
import '../../data/repositories/coupons_repository.dart';
import '../../logic/states/coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final CouponsRepository _repository;

  CouponsCubit(this._repository) : super(const CouponsState.initial());

  Future<void> getCoupons() async {
    emit(const CouponsState.loading());

    final result = await _repository.getCoupons();

    result.when(
      success: (couponsList) {
        emit(CouponsState.loaded(couponsList));
      },
      failure: (error) {
        emit(CouponsState.error(error.errorMessage));
      },
    );
  }

  Future<void> createCoupon(CreateCouponRequest request) async {
    emit(const CouponsState.loading());

    final result = await _repository.createCoupon(request);

    result.when(
      success: (_) {
        // Reload coupons list
        getCoupons();
      },
      failure: (error) {
        emit(CouponsState.error(error.errorMessage));
      },
    );
  }

  Future<void> updateCoupon(String id, UpdateCouponRequest request) async {
    emit(const CouponsState.loading());

    final result = await _repository.updateCoupon(id, request);

    result.when(
      success: (_) {
        // Reload coupons list
        getCoupons();
      },
      failure: (error) {
        emit(CouponsState.error(error.errorMessage));
      },
    );
  }

  Future<void> deleteCoupon(String id) async {
    emit(const CouponsState.loading());

    final result = await _repository.deleteCoupon(id);

    result.when(
      success: (_) {
        // Reload coupons list
        getCoupons();
      },
      failure: (error) {
        emit(CouponsState.error(error.errorMessage));
      },
    );
  }
}

