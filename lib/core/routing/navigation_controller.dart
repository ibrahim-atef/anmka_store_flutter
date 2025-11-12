import 'package:flutter/material.dart';

enum AppTab {
  dashboard,
  products,
  orders,
  customers,
  settings,
}

class NavigationController extends ChangeNotifier {
  AppTab _currentTab = AppTab.dashboard;
  final Map<AppTab, Object?> _tabPayload = {};

  AppTab get currentTab => _currentTab;
  Object? payloadFor(AppTab tab) => _tabPayload[tab];

  void setTab(AppTab tab, {Object? payload}) {
    if (_currentTab == tab && payload == null) return;
    _currentTab = tab;
    if (payload != null) {
      _tabPayload[tab] = payload;
    }
    notifyListeners();
  }
}

