import 'dart:async';

import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _hasSeenWelcome = false;

  String? _name;
  String? _website;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get hasSeenWelcome => _hasSeenWelcome;

  String get displayName => _name ?? 'مدير المتجر';
  String? get website => _website;

  Future<bool> login({
    required String username,
    required String password,
    required String website,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final success = username.isNotEmpty && password.isNotEmpty && website.isNotEmpty;

    if (success) {
      _isAuthenticated = true;
      _name = username;
      _website = website;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void markWelcomeSeen() {
    if (!_hasSeenWelcome) {
      _hasSeenWelcome = true;
      notifyListeners();
    }
  }

  void resetWelcome() {
    _hasSeenWelcome = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _name = null;
    _website = null;
    notifyListeners();
  }
}

