import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // FCM v1 API configuration
  // WARNING: Storing service account credentials in client code is insecure!
  // For production, use Firebase Cloud Functions or a secure backend server
  final String _projectId =
      'medical-app-2c545'; // Replace with your Firebase project ID

  // Service account credentials (replace with your actual service account JSON)
  final Map<String, dynamic> _serviceAccountJson = {
    "type": "service_account",
    "project_id": "medical-app-2c545",
    "private_key_id": "REMOVED_KEY_ID",
    "private_key":
        "REDACTED_PRIVATE_KEY_REMOVED_FOR_SECURITY",
    "client_email":
        "redacted-service-account@removed.iam.gserviceaccount.com",
    "client_id": "REMOVED_CLIENT_ID",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40medical-app-2c545.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com",
  };

  Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    LoggerUtil.i('User granted permission: ${settings.authorizationStatus}');

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    LoggerUtil.i('FCM Token: $token');

    // Set up handlers
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _onMessage(RemoteMessage message) {
    LoggerUtil.i('Got a message whilst in the foreground!');
    LoggerUtil.i('Message data: ${message.data}');

    if (message.notification != null) {
      LoggerUtil.i(
        'Message also contained a notification: ${message.notification}',
      );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    LoggerUtil.i('A new onMessageOpenedApp event was published!');
    LoggerUtil.i('Message data: ${message.data}');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    LoggerUtil.i('Handling a background message: ${message.messageId}');
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<String?> _getAccessToken() async {
    try {
      final accountCredentials = auth.ServiceAccountCredentials.fromJson(
        _serviceAccountJson,
      );
      final client = await auth.clientViaServiceAccount(accountCredentials, [
        'https://www.googleapis.com/auth/firebase.messaging',
      ]);
      final accessToken = client.credentials.accessToken.data;
      client.close();
      return accessToken;
    } catch (e) {
      LoggerUtil.e('Error getting access token: $e');
      return null;
    }
  }

  Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    // WARNING: Sending notifications from client-side with service account credentials is insecure!
    // For production, use Firebase Cloud Functions or a secure backend server

    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        LoggerUtil.e('Failed to get access token');
        return;
      }

      final response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
            'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
          },
        }),
      );

      if (response.statusCode == 200) {
        LoggerUtil.i('Notification sent successfully');
      } else {
        LoggerUtil.e(
          'Failed to send notification: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      LoggerUtil.e('Error sending notification: $e');
    }
  }
}
