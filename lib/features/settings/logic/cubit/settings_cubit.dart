import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/request/invite_team_member_request.dart';
import '../../data/models/request/update_notification_settings_request.dart';
import '../../data/models/request/update_store_settings_request.dart';
import '../../data/repositories/settings_repository.dart';
import '../../logic/states/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(const SettingsState.initial());

  Future<void> loadSettings() async {
    emit(const SettingsState.loading());

    final storeResult = await _repository.getStoreSettings();
    final notificationResult = await _repository.getNotificationSettings();
    final teamResult = await _repository.getTeam();

    storeResult.when(
      success: (storeSettings) {
        notificationResult.when(
          success: (notificationSettings) {
            teamResult.when(
              success: (team) {
                emit(SettingsState.loaded(
                  storeSettings: storeSettings,
                  notificationSettings: notificationSettings,
                  team: team,
                ));
              },
              failure: (error) {
                emit(SettingsState.error(error.errorMessage));
              },
            );
          },
          failure: (error) {
            emit(SettingsState.error(error.errorMessage));
          },
        );
      },
      failure: (error) {
        emit(SettingsState.error(error.errorMessage));
      },
    );
  }

  Future<void> updateStoreSettings(
      UpdateStoreSettingsRequest request) async {
    final result = await _repository.updateStoreSettings(request);

    result.when(
      success: (_) {
        // Reload all settings
        loadSettings();
      },
      failure: (error) {
        emit(SettingsState.error(error.errorMessage));
      },
    );
  }

  Future<void> updateNotificationSettings(
      UpdateNotificationSettingsRequest request) async {
    final result = await _repository.updateNotificationSettings(request);

    result.when(
      success: (_) {
        // Reload all settings
        loadSettings();
      },
      failure: (error) {
        emit(SettingsState.error(error.errorMessage));
      },
    );
  }

  Future<void> inviteTeamMember(InviteTeamMemberRequest request) async {
    final result = await _repository.inviteTeamMember(request);

    result.when(
      success: (_) {
        // Reload all settings
        loadSettings();
      },
      failure: (error) {
        emit(SettingsState.error(error.errorMessage));
      },
    );
  }

  Future<void> resetTeamPassword(int id) async {
    final result = await _repository.resetTeamPassword(id);

    result.when(
      success: (_) {
        // Reload all settings
        loadSettings();
      },
      failure: (error) {
        emit(SettingsState.error(error.errorMessage));
      },
    );
  }
}

