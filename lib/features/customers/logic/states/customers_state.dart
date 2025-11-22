import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/customer_response.dart';
import '../../data/models/response/customers_list_response.dart';

part 'customers_state.freezed.dart';

@freezed
class CustomersState with _$CustomersState {
  const factory CustomersState.initial() = _Initial;
  const factory CustomersState.loading() = _Loading;
  const factory CustomersState.loaded(CustomersListResponse customersList) = _Loaded;
  const factory CustomersState.customerLoaded(CustomerResponse customer) = _CustomerLoaded;
  const factory CustomersState.error(String message) = _Error;
}

