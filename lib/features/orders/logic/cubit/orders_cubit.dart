import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/request/create_order_request.dart';
import '../../data/repositories/orders_repository.dart';
import '../../logic/states/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit(this._repository) : super(const OrdersState.initial());

  Future<void> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? paymentStatus,
    String? shippingStatus,
  }) async {
    emit(const OrdersState.loading());

    final result = await _repository.getOrders(
      page: page,
      limit: limit,
      status: status,
      paymentStatus: paymentStatus,
      shippingStatus: shippingStatus,
    );

    result.when(
      success: (ordersList) {
        emit(OrdersState.loaded(ordersList));
      },
      failure: (error) {
        emit(OrdersState.error(error.errorMessage));
      },
    );
  }

  Future<void> getOrderById(String id) async {
    emit(const OrdersState.loading());

    final result = await _repository.getOrderById(id);

    result.when(
      success: (order) {
        emit(OrdersState.orderLoaded(order));
      },
      failure: (error) {
        emit(OrdersState.error(error.errorMessage));
      },
    );
  }

  Future<void> createOrder(CreateOrderRequest request) async {
    emit(const OrdersState.loading());

    final result = await _repository.createOrder(request);

    result.when(
      success: (_) {
        getOrders();
      },
      failure: (error) {
        emit(OrdersState.error(error.errorMessage));
      },
    );
  }

  Future<void> updateOrderStatus(String id, String status) async {
    emit(const OrdersState.loading());

    final result = await _repository.updateOrderStatus(id, status);

    result.when(
      success: (_) {
        getOrders();
      },
      failure: (error) {
        emit(OrdersState.error(error.errorMessage));
      },
    );
  }

  Future<void> updatePaymentStatus(String id, String paymentStatus) async {
    emit(const OrdersState.loading());

    final result = await _repository.updatePaymentStatus(id, paymentStatus);

    result.when(
      success: (_) {
        getOrders();
      },
      failure: (error) {
        emit(OrdersState.error(error.errorMessage));
      },
    );
  }

  Future<void> updateShippingStatus(String id, String shippingStatus) async {
    emit(const OrdersState.loading());

    final result = await _repository.updateShippingStatus(id, shippingStatus);

    result.when(
      success: (_) {
        getOrders();
      },
      failure: (error) {
        emit(OrdersState.error(error.errorMessage));
      },
    );
  }
}
