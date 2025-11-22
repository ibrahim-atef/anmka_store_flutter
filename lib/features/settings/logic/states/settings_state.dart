import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/notification_settings_response.dart';
import '../../data/models/response/store_settings_response.dart';
import '../../data/models/response/team_list_response.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = _Initial;
  const factory SettingsState.loading() = _Loading;
  const factory SettingsState.loaded({
    required StoreSettingsResponse storeSettings,
    required NotificationSettingsResponse notificationSettings,
    required TeamListResponse team,
  }) = _Loaded;
  const factory SettingsState.error(String message) = _Error;
}

