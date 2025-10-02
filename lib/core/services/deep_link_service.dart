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

    String? patientId;

    // Handle both custom scheme (myapp://) and HTTPS universal links
    if (uri.scheme == 'myapp' && uri.host == 'addPatient') {
      // Custom scheme: myapp://addPatient?id=xxx
      patientId = uri.queryParameters['id'];
      debugPrint('Custom scheme detected');
    } else if (uri.scheme == 'https' && uri.path.contains('addPatient')) {
      // HTTPS universal link: https://your-domain.web.app/addPatient?id=xxx
      patientId = uri.queryParameters['id'];
      debugPrint('Universal link (HTTPS) detected');
    }

    if (patientId != null && patientId.isNotEmpty) {
      debugPrint('Patient ID from deep link: $patientId');

      // Navigate to patient list page with the ID
      NavigationService.instance.navigatorKey.currentState?.pushNamed(
        '/patient-all-list',
        arguments: {'patientId': patientId},
      );

      // Notify listeners (e.g., PatientAllListPage)
      if (onPatientIdReceived != null) {
        onPatientIdReceived!(patientId);
      }
    } else {
      debugPrint('No patient ID found in deep link');
    }
  }

  /// Clean up resources
  void dispose() {
    _sub?.cancel();
  }
}
