import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/notifications_list_response.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _Initial;
  const factory NotificationsState.loading() = _Loading;
  const factory NotificationsState.loaded(NotificationsListResponse notificationsList) = _Loaded;
  const factory NotificationsState.error(String message) = _Error;
}

