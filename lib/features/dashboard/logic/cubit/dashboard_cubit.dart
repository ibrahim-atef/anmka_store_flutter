import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../logic/states/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;

  DashboardCubit(this._repository) : super(const DashboardState.initial());

  Future<void> getStats() async {
    emit(const DashboardState.loading());

    final result = await _repository.getStats();

    result.when(
      success: (stats) {
        emit(DashboardState.loaded(stats));
      },
      failure: (error) {
        emit(DashboardState.error(error.errorMessage));
      },
    );
  }
}
