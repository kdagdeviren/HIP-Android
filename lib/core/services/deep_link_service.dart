import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription? _sub;

  // Callback for handling patient ID from deep link
  Function(String)? onPatientIdReceived;

  /// Initialize deep link handling
  Future<void> initialize() async {
    _appLinks = AppLinks();

    // Handle initial link if app was opened via deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // Handle links while app is running
    _sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        debugPrint('Error listening to link stream: $err');
      },
    );
  }

  /// Parse and handle deep link
  void _handleDeepLink(Uri uri) {
    debugPrint('Deep link received: $uri');
    debugPrint('Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');
    debugPrint('Query parameters: ${uri.queryParameters}');

    String? patientId;

    // Handle both custom scheme (myapp://) and HTTPS universal links
    // Case-insensitive check
    if (uri.scheme == 'myapp' && uri.host.toLowerCase() == 'addpatient') {
      // Custom scheme: myapp://addpatient?id=xxx
      patientId = uri.queryParameters['id'];
      debugPrint('Custom scheme detected - patientId: $patientId');
    } else if (uri.scheme == 'https' &&
        uri.path.toLowerCase().contains('addpatient')) {
      // HTTPS universal link: https://your-domain.web.app/addPatient?id=xxx
      patientId = uri.queryParameters['id'];
      debugPrint('Universal link (HTTPS) detected - patientId: $patientId');
    }

    if (patientId != null && patientId.isNotEmpty) {
      debugPrint('Patient ID from deep link: $patientId');

      // Kısa gecikme ekle - NavigationService'in hazır olmasını bekle
      Future.delayed(const Duration(milliseconds: 300), () {
        final navigator = NavigationService.instance.navigatorKey.currentState;

        if (navigator != null) {
          debugPrint('Navigating to patient-all-list with autoAdd=true');

          // Mevcut route'u kaldır ve yeni route'u ekle
          navigator.pushNamedAndRemoveUntil(
            '/patient-all-list',
            (route) => route.settings.name == '/' || route.isFirst,
            arguments: {
              'patientId': patientId,
              'autoAdd': true, // Otomatik ekleme flag'i
            },
          );
        } else {
          debugPrint('Navigator not ready, trying alternative method');

          // Alternatif: Callback ile bildir
          if (onPatientIdReceived != null && patientId != null) {
            onPatientIdReceived!(patientId);
          }
        }
      });
    } else {
      debugPrint('No patient ID found in deep link');
    }
  }

  /// Clean up resources
  void dispose() {
    _sub?.cancel();
  }
}
