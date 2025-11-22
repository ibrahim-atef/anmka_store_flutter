import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/customers_repository.dart';
import '../../logic/states/customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  final CustomersRepository _repository;

  CustomersCubit(this._repository) : super(const CustomersState.initial());

  Future<void> getCustomers({
    int page = 1,
    int limit = 20,
    String? tier,
    String? search,
  }) async {
    emit(const CustomersState.loading());

    final result = await _repository.getCustomers(
      page: page,
      limit: limit,
      tier: tier,
      search: search,
    );

    result.when(
      success: (customersList) {
        emit(CustomersState.loaded(customersList));
      },
      failure: (error) {
        emit(CustomersState.error(error.errorMessage));
      },
    );
  }

  Future<void> getCustomerById(int id) async {
    emit(const CustomersState.loading());

    final result = await _repository.getCustomerById(id);

    result.when(
      success: (customer) {
        emit(CustomersState.customerLoaded(customer));
      },
      failure: (error) {
        emit(CustomersState.error(error.errorMessage));
      },
    );
  }
}
