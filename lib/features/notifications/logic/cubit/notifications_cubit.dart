import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../logic/states/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit(this._repository) : super(const NotificationsState.initial());

  Future<void> getNotifications({
    String? category,
    bool? read,
    int? limit,
  }) async {
    emit(const NotificationsState.loading());

    final result = await _repository.getNotifications(
      category: category,
      read: read,
      limit: limit,
    );

    result.when(
      success: (notificationsList) {
        emit(NotificationsState.loaded(notificationsList));
      },
      failure: (error) {
        emit(NotificationsState.error(error.errorMessage));
      },
    );
  }

  Future<void> markNotificationAsRead(int id) async {
    final result = await _repository.markNotificationAsRead(id);

    result.when(
      success: (_) {
        // Reload notifications
        getNotifications();
      },
      failure: (error) {
        emit(NotificationsState.error(error.errorMessage));
      },
    );
  }

  Future<void> markAllNotificationsAsRead() async {
    final result = await _repository.markAllNotificationsAsRead();

    result.when(
      success: (_) {
        // Reload notifications
        getNotifications();
      },
      failure: (error) {
        emit(NotificationsState.error(error.errorMessage));
      },
    );
  }
}

