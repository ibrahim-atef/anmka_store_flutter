import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/order_response.dart';
import '../../data/models/response/orders_list_response.dart';

part 'orders_state.freezed.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState.initial() = _Initial;
  const factory OrdersState.loading() = _Loading;
  const factory OrdersState.loaded(OrdersListResponse ordersList) = _Loaded;
  const factory OrdersState.orderLoaded(OrderResponse order) = _OrderLoaded;
  const factory OrdersState.error(String message) = _Error;
}

