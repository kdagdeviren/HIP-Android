import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._(); // private constructor

  static final NavigationService instance = NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Route stack'i manuel olarak yönetmek için
  final List<String> _routeStack = [];

  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    _routeStack.add(routeName); // Stack'e ekle
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void goBack([dynamic result]) {
    if (_routeStack.isNotEmpty) {
      _routeStack.removeLast(); // Stack'ten çıkar
    }
    navigatorKey.currentState?.pop(result);
  }

  Future<dynamic>? navigateToReplacement(
    String routeName, {
    Object? arguments,
  }) {
    if (_routeStack.isNotEmpty) {
      _routeStack.removeLast(); // Önceki route'u çıkar
    }
    _routeStack.add(routeName); // Yeni route'u ekle
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic>? navigateToAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) {
    _routeStack.clear(); // Tüm stack'i temizle
    _routeStack.add(routeName); // Yeni route'u ekle
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  // Bir önceki sayfanın routeName'ini döndüren metot
  String? getPreviousRouteName() {
    if (_routeStack.length > 1) {
      return _routeStack[_routeStack.length - 2];
    }
    return null; // Stack'te tek route varsa veya boşsa null
  }
}
