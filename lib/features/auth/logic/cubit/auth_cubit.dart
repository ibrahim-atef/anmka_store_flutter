import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/network/dio_factory.dart';
import '../../data/models/request/forgot_password_request.dart';
import '../../data/models/request/login_request.dart';
import '../../data/models/response/login_response.dart';
import '../../data/repositories/auth_repository.dart';
import '../../logic/states/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated by checking for saved token
  Future<void> _checkAuthStatus() async {
    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefHelper.tokenKey);
    if (token.isNotEmpty) {
      // Try to restore user data from storage
      final userDataJson =
          await SharedPrefHelper.getString(SharedPrefHelper.userDataKey);
      if (userDataJson.isNotEmpty) {
        try {
          final userData = jsonDecode(userDataJson);
          final loginResponse = LoginResponse.fromJson({
            'token': token,
            'user': userData,
          });
          emit(AuthState.authenticated(loginResponse));
          return;
        } catch (e) {
          // If parsing fails, clear invalid data
          await _clearAuthData();
        }
      }
    }
    emit(const AuthState.unauthenticated());
  }

  /// Clear all authentication data
  Future<void> _clearAuthData() async {
    await SharedPrefHelper.removeSecuredString(SharedPrefHelper.tokenKey);
    await SharedPrefHelper.removeData(SharedPrefHelper.userDataKey);
  }

  Future<void> login({
    required String username,
    required String password,
    required String website,
  }) async {
    emit(const AuthState.loading());

    final request = LoginRequest(
      username: username,
      password: password,
      website: website,
    );

    final result = await _repository.login(request);

    result.when(
      success: (loginResponse) async {
        log('Login success - saving token and user data');
        // Save token to secure storage and set it in DioFactory
        await DioFactory.setToken(loginResponse.token);
        log('Token saved to secure storage');
        // Save user data to SharedPreferences
        await SharedPrefHelper.setData(
          SharedPrefHelper.userDataKey,
          jsonEncode(loginResponse.user.toJson()),
        );
        log('User data saved - emitting authenticated state');
        // Emit authenticated state after all data is saved
        emit(AuthState.authenticated(loginResponse));
        log('Authenticated state emitted');
      },
      failure: (error) {
        log('Login failed: ${error.errorMessage}');
        emit(AuthState.error(error.errorMessage));
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());

    final result = await _repository.logout();

    result.when(
      success: (_) async {
        // Clear token and all stored data
        await _clearAuthData();
        await DioFactory.clearToken();
        emit(const AuthState.unauthenticated());
      },
      failure: (error) async {
        // Even if logout fails on server, clear local data
        await _clearAuthData();
        await DioFactory.clearToken();
        emit(AuthState.error(error.errorMessage));
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthState.loading());

    final request = ForgotPasswordRequest(email: email);

    final result = await _repository.forgotPassword(request);

    result.when(
      success: (_) {
        emit(const AuthState.initial());
      },
      failure: (error) {
        emit(AuthState.error(error.errorMessage));
      },
    );
  }

  void reset() {
    emit(const AuthState.initial());
  }
}
