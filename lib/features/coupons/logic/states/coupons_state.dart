import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/coupons_list_response.dart';

part 'coupons_state.freezed.dart';

@freezed
class CouponsState with _$CouponsState {
  const factory CouponsState.initial() = _Initial;
  const factory CouponsState.loading() = _Loading;
  const factory CouponsState.loaded(CouponsListResponse couponsList) = _Loaded;
  const factory CouponsState.error(String message) = _Error;
}

